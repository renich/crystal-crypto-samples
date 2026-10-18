require "openssl"

module CrystalCryptoSamples
  # Orchestrates the Phase 2 end-to-end D-Bus CTAP2 authenticator ceremony
  # transporting canonical CBOR frames over `crystal-dbus-native` to a
  # `crystal-tpm2-tss` + `crystal-pqc-constant` responder.
  module Ctap2DbusCeremony
    # D-Bus object path for the CTAP2 authenticator service.
    OBJECT_PATH = "/org/evalinux/Ctap2Authenticator1"

    # D-Bus interface and bus name for the CTAP2 authenticator service.
    INTERFACE = "org.evalinux.Ctap2Authenticator1"

    # D-Bus method member for CTAP2 credential creation and attestation.
    METHOD_NAME = "MakeCredential"

    # Relying Party identifier bound into the CTAP2 verification digest.
    RP_ID = "evalinux.com"

    # Domain-separation context string for PQC attestation signatures.
    ATTESTATION_CTX = "EVALINUX-CTAP2-DBUS-V1"

    # Executes the complete D-Bus CTAP2 `MakeCredential` RPC and dual verification.
    def self.run(io : IO = STDOUT) : Nil
      io.puts "\n[7] Testing End-to-End D-Bus CTAP2 Authenticator Ceremony..."
      Crystal::Pqc::Constant::Sodium.init

      tpm_device = Crystal::Tpm2::Tss::TPMDevice.new
      cred_manager = Crystal::Tpm2::Tss::FIDO2CredentialManager.new(tpm_device)
      dsa = Crystal::Pqc::Constant::MLDSAKeyPair.generate
      begin
        rpc_ok, verify_ok = run_dbus_ctap2_exchange(cred_manager, dsa)
        io.puts "CTAP2 D-Bus MakeCredential (#{OBJECT_PATH}, ay -> ay): #{rpc_ok ? "SUCCESS" : "FAILED"}"
        io.puts "CTAP2 TPM2 P-256 (64B) + ML-DSA-65 (3309B) dual attestation verification: " \
                "#{verify_ok ? "SUCCESS" : "FAILED"}"
      ensure
        dsa.dispose
      end
    end

    private def self.run_dbus_ctap2_exchange(
      cred_manager : Crystal::Tpm2::Tss::FIDO2CredentialManager, dsa : Crystal::Pqc::Constant::MLDSAKeyPair,
    ) : Tuple(Bool, Bool)
      client_sock, server_sock = UNIXSocket.pair(Socket::Type::STREAM)
      done = Channel(Nil).new(1)
      spawn do
        serve_ctap2_authenticator(server_sock, cred_manager, dsa)
      ensure
        server_sock.close
        done.send(nil)
      end

      execute_client_call(client_sock, dsa, done)
    end

    private def self.execute_client_call(
      client_sock : UNIXSocket, dsa : Crystal::Pqc::Constant::MLDSAKeyPair, done : Channel(Nil),
    ) : Tuple(Bool, Bool)
      conn = Crystal::Dbus::Native::DBusConnection.new(client_sock)
      begin
        conn.start(1000_u32, hello: true, negotiate_unix_fd: true)
        challenge = Bytes.new(32, 0x5a_u8)
        req_cbor = encode_request(challenge)
        reply = conn.call(INTERFACE, OBJECT_PATH, INTERFACE, METHOD_NAME, "ay", bytes_to_dbus_ay(req_cbor))
        resp_cbor = dbus_ay_to_bytes(reply.decode_body)
        {!resp_cbor.empty?, verify_response(resp_cbor, challenge, dsa, RP_ID)}
      ensure
        conn.close
        done.receive
      end
    end

    private def self.serve_ctap2_authenticator(
      server : UNIXSocket,
      cred_manager : Crystal::Tpm2::Tss::FIDO2CredentialManager,
      dsa : Crystal::Pqc::Constant::MLDSAKeyPair,
    ) : Nil
      accept_sasl_and_hello(server)
      call_msg = Crystal::Dbus::Native::DBusMessage.parse(server)
      validate_ctap2_call_header(call_msg)
      req_cbor = dbus_ay_to_bytes(call_msg.decode_body)
      resp_cbor = process_make_credential(req_cbor, cred_manager, dsa)
      reply_body = Crystal::Dbus::Native::BodyCodec.encode("ay", bytes_to_dbus_ay(resp_cbor))
      reply = Crystal::Dbus::Native::DBusMessage.method_return(2_u32, call_msg.serial, ":1.42", "ay", reply_body)
      reply.serialize(server)
      server.flush
    end

    private def self.validate_ctap2_call_header(call_msg : Crystal::Dbus::Native::DBusMessage) : Nil
      return if call_msg.path == OBJECT_PATH && call_msg.interface == INTERFACE && call_msg.member == METHOD_NAME
      raise RuntimeError.new("Unexpected D-Bus CTAP2 routing header")
    end

    # Services and validates the server side of a SASL `EXTERNAL`,
    # `NEGOTIATE_UNIX_FD`, and `org.freedesktop.DBus.Hello` handshake.
    def self.accept_sasl_and_hello(server : UNIXSocket) : Nil
      verify_sasl_exchange(server)
      hello_call = Crystal::Dbus::Native::DBusMessage.parse(server)
      raise RuntimeError.new("Expected D-Bus Hello call") unless hello_call.member == "Hello"
      body = Crystal::Dbus::Native::BodyCodec.encode("s", [":1.42".as(Crystal::Dbus::Native::Value)])
      reply = Crystal::Dbus::Native::DBusMessage.method_return(
        1_u32, hello_call.serial, ":1.42", "s", body
      )
      reply.serialize(server)
      server.flush
    end

    private def self.verify_sasl_exchange(server : UNIXSocket) : Nil
      raise RuntimeError.new("Missing NUL credential byte") unless server.read_byte == 0_u8
      auth_line = server.gets("\r\n", chomp: true) || ""
      raise RuntimeError.new("Expected SASL AUTH EXTERNAL") unless auth_line.starts_with?("AUTH EXTERNAL")
      server << "OK 0123456789abcdef0123456789abcdef\r\n"
      server.flush
      fd_line = server.gets("\r\n", chomp: true)
      raise RuntimeError.new("Expected NEGOTIATE_UNIX_FD") unless fd_line == "NEGOTIATE_UNIX_FD"
      server << "AGREE_UNIX_FD\r\n"
      server.flush
      begin_line = server.gets("\r\n", chomp: true)
      raise RuntimeError.new("Expected SASL BEGIN") unless begin_line == "BEGIN"
    end

    # Encodes a canonical integer-keyed CBOR `MakeCredential` request map.
    def self.encode_request(challenge : Bytes, rp_id : String = RP_ID) : Bytes
      req = Hash(Crystal::Cbor::Fido::Value, Crystal::Cbor::Fido::Value).new
      req[1_i64] = challenge
      req[2_i64] = rp_id
      req[3_i64] = "ctap2-credential-01"
      Crystal::Cbor::Fido.encode(req)
    end

    # Decodes a canonical CBOR `MakeCredential` request, signs `SHA256(rp_id || challenge)`
    # with both TPM 2.0 NIST P-256 and `ML-DSA-65`, and encodes the CBOR response.
    def self.process_make_credential(
      req_cbor : Bytes,
      cred_manager : Crystal::Tpm2::Tss::FIDO2CredentialManager,
      dsa : Crystal::Pqc::Constant::MLDSAKeyPair,
    ) : Bytes
      decoded = Crystal::Cbor::Fido.decode(req_cbor)
      return Bytes.empty unless decoded.is_a?(Hash)

      challenge = decoded[1_i64]?.as?(Bytes)
      rp_id = decoded[2_i64]?.as?(String)
      cred_id = decoded[3_i64]?.as?(String)
      return Bytes.empty unless challenge && rp_id && cred_id

      credential = cred_manager.get_or_create_credential(cred_id)
      digest = ctap2_digest(rp_id, challenge)
      encode_credential_response(credential, digest, dsa)
    end

    private def self.encode_credential_response(
      credential : Crystal::Tpm2::Tss::FIDO2Credential,
      digest : Bytes,
      dsa : Crystal::Pqc::Constant::MLDSAKeyPair,
    ) : Bytes
      p256_sig = credential.sign(digest)
      pqc_sig = dsa.sign(digest, context: ATTESTATION_CTX.to_slice)
      resp = Hash(Crystal::Cbor::Fido::Value, Crystal::Cbor::Fido::Value).new
      resp[1_i64] = credential.credential_id
      resp[2_i64] = p256_sig.r
      resp[3_i64] = p256_sig.s
      resp[4_i64] = pqc_sig
      resp[5_i64] = credential.public_key_x
      resp[6_i64] = credential.public_key_y
      Crystal::Cbor::Fido.encode(resp)
    end

    # Verifies the canonical CBOR `MakeCredential` response using the attested
    # NIST P-256 public key coordinates and `ML-DSA-65` public key.
    def self.verify_response(
      resp_cbor : Bytes,
      challenge : Bytes,
      dsa : Crystal::Pqc::Constant::MLDSAKeyPair,
      rp_id : String = RP_ID,
    ) : Bool
      decoded = Crystal::Cbor::Fido.decode(resp_cbor)
      return false unless decoded.is_a?(Hash)
      return false unless decoded[1_i64]?.is_a?(String)

      sig_r = decoded[2_i64]?.as?(Bytes)
      sig_s = decoded[3_i64]?.as?(Bytes)
      pqc_sig = decoded[4_i64]?.as?(Bytes)
      pub_x = decoded[5_i64]?.as?(Bytes)
      pub_y = decoded[6_i64]?.as?(Bytes)
      return false unless sig_r && sig_s && pqc_sig && pub_x && pub_y

      digest = ctap2_digest(rp_id, challenge)
      tpm_sig = Crystal::Tpm2::Tss::ECDSASignature.new(sig_r, sig_s)
      Crystal::Tpm2::Tss::P256Key.verify_public_key(pub_x, pub_y, digest, tpm_sig) &&
        dsa.verify(digest, pqc_sig, context: ATTESTATION_CTX.to_slice)
    end

    private def self.ctap2_digest(rp_id : String, challenge : Bytes) : Bytes
      digest = OpenSSL::Digest.new("SHA256")
      digest.update(rp_id.to_slice)
      digest.update(challenge)
      digest.final
    end

    private def self.bytes_to_dbus_ay(bytes : Bytes) : Array(Crystal::Dbus::Native::Value)
      arr = Array(Crystal::Dbus::Native::Value).new(bytes.size)
      bytes.each { |byte| arr << byte.as(Crystal::Dbus::Native::Value) }
      [arr.as(Crystal::Dbus::Native::Value)]
    end

    private def self.dbus_ay_to_bytes(decoded : Array(Crystal::Dbus::Native::Value)) : Bytes
      first = decoded[0]?
      return Bytes.empty unless first.is_a?(Array(Crystal::Dbus::Native::Value))

      out = Bytes.new(first.size)
      first.each_with_index do |item, idx|
        return Bytes.empty unless item.is_a?(UInt8)
        out[idx] = item
      end
      out
    end
  end
end
