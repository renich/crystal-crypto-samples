require "crystal-cbor-fido"
require "crystal-dbus-native"
require "crystal-ecc-constant"
require "crystal-pqc-constant"
require "crystal-tpm2-tss"
require "socket"

# End-to-end integration harness and demonstration runner for the EVALinux
# Crystal cryptographic library suite.
module CrystalCryptoSamples
  # Current version of the `crystal-crypto-samples` integration suite.
  VERSION = "0.3.0"

  # Executes all five cryptographic integration demonstrations and writes
  # structured status output to *io*.
  def self.run_samples(io : IO = STDOUT) : Nil
    io.puts "=========================================================="
    io.puts "          EVALinux Crypto Suite - Sample App              "
    io.puts "=========================================================="

    run_cbor_sample(io)
    run_ecc_sample(io)
    run_dbus_sample(io)
    run_tpm2_sample(io)
    run_pqc_sample(io)

    io.puts "\nAll dependencies successfully compiled and executed!"
    io.puts "=========================================================="
  end

  # Demonstrates canonical CTAP2/FIDO2 CBOR map encoding, canonical Float16
  # narrowing, UInt64 serialization, and decoding.
  def self.run_cbor_sample(io : IO = STDOUT) : Nil
    io.puts "\n[1] Testing CBOR FIDO Encoding..."
    data = Hash(Crystal::Cbor::Fido::Value, Crystal::Cbor::Fido::Value).new
    data["challenge"] = "rand123"
    data["user_id"] = 100_i64
    data["counter"] = 18_446_744_073_709_551_615_u64
    data["weight"] = 1.5_f64

    bytes = Crystal::Cbor::Fido.encode(data)
    io.puts "Encoded CBOR Payload: #{bytes.hexstring}"

    float16_bytes = Crystal::Cbor::Fido.encode(1.5_f64)
    io.puts "Canonical Float16 (1.5): #{float16_bytes.hexstring}"

    decoded = Crystal::Cbor::Fido.decode(bytes)
    io.puts "Decoded CBOR Payload: #{decoded}"
  end

  # Demonstrates constant-time Ed25519 digital signatures and X25519 ECDH
  # shared secret agreement with guarded libsodium memory disposal.
  def self.run_ecc_sample(io : IO = STDOUT) : Nil
    io.puts "\n[2] Testing ECC Constant Time Signatures & X25519 ECDH..."
    Crystal::Ecc::Constant::Sodium.init
    run_ed25519_demo(io)
    run_x25519_demo(io)
  end

  private def self.run_ed25519_demo(io : IO) : Nil
    keypair = Crystal::Ecc::Constant::Ed25519KeyPair.generate
    begin
      message = "Strictly FIDO2 assertion".to_slice
      signature = keypair.sign(message)
      is_valid = keypair.verify(message, signature)
      io.puts "Signature verification: #{is_valid ? "SUCCESS" : "FAILED"}"
    ensure
      keypair.dispose
    end
  end

  private def self.run_x25519_demo(io : IO) : Nil
    alice = Crystal::Ecc::Constant::X25519KeyPair.generate
    bob = Crystal::Ecc::Constant::X25519KeyPair.generate
    begin
      agreed = alice.diffie_hellman(bob.public_key).consume do |alice_secret|
        bob.diffie_hellman(alice.public_key).consume do |bob_secret|
          Crystal::Ecc::Constant::Sodium.constant_time_equal?(alice_secret, bob_secret)
        end
      end
      io.puts "X25519 ECDH shared secret agreement: #{agreed ? "SUCCESS" : "FAILED"}"
    ensure
      alice.dispose
      bob.dispose
    end
  end

  # Demonstrates native D-Bus signature validation, recursive `a{sv}` body
  # marshaling, SASL EXTERNAL authentication, UNIX FD negotiation, and `Hello`.
  def self.run_dbus_sample(io : IO = STDOUT) : Nil
    io.puts "\n[3] Testing Native DBus Structures..."
    Crystal::Dbus::Native::SignatureValidator.validate("a{sv}")
    io.puts "Signature validation (a{sv}): VALID"
    run_dbus_body_demo(io)

    client, server = UNIXSocket.pair(Socket::Type::STREAM)
    done = Channel(Nil).new(1)
    spawn do
      serve_mock_dbus_handshake(server)
    ensure
      server.close
      done.send(nil)
    end

    conn = Crystal::Dbus::Native::DBusConnection.new(client)
    begin
      unique_name = conn.start(1000_u32, hello: true, negotiate_unix_fd: true)
      io.puts "DBus connection authenticated via SASL " \
              "(GUID: #{conn.server_guid}, unique_name: #{unique_name}, unix_fds: true)."
    ensure
      conn.close
      done.receive
    end
  end

  private def self.run_dbus_body_demo(io : IO) : Nil
    dict = Hash(Crystal::Dbus::Native::Value, Crystal::Dbus::Native::Value).new
    dict["pin"] = Crystal::Dbus::Native::Variant.new("u", 42_u32)
    encoded = Crystal::Dbus::Native::BodyCodec.encode("a{sv}", [dict] of Crystal::Dbus::Native::Value)
    decoded = Crystal::Dbus::Native::BodyCodec.decode("a{sv}", encoded)
    io.puts "DBus BodyCodec (a{sv}) roundtrip: #{decoded.size == 1 ? "SUCCESS" : "FAILED"}"
  end

  private def self.serve_mock_dbus_handshake(server : UNIXSocket) : Nil
    server.read_byte
    server.gets("\r\n")
    server << "OK 0123456789abcdef0123456789abcdef\r\n"
    server.flush
    server.gets("\r\n")
    server << "AGREE_UNIX_FD\r\n"
    server.flush
    server.gets("\r\n")

    call = Crystal::Dbus::Native::DBusMessage.parse(server)
    body = IO::Memory.new
    body.write_bytes(5_u32, IO::ByteFormat::LittleEndian)
    body << ":1.42\0"
    reply = Crystal::Dbus::Native::DBusMessage.method_return(
      serial: 1_u32,
      reply_serial: call.serial,
      destination: ":1.42",
      signature: "s",
      body: body.to_slice
    )
    reply.serialize(server)
    server.flush
  end

  # Demonstrates TPM 2.0 NV-backed FIDO2 credential persistence, real NIST P-256
  # ECDSA signing/verification, and KDFa XOR + AES-128-CFB parameter encryption.
  def self.run_tpm2_sample(io : IO = STDOUT) : Nil
    io.puts "\n[4] Testing TPM2 TSS Memory Structures & Parameter Encryption..."
    tpm_mock = Crystal::Tpm2::Tss::TPMDevice.new
    credential_manager = Crystal::Tpm2::Tss::FIDO2CredentialManager.new(tpm_mock)
    credential = credential_manager.get_or_create_credential("user-credential-1234")
    handle_hex = credential.persistent_handle.to_s(16)
    io.puts "Derived hardware-bound auth key: " \
            "[REDACTED #{credential.auth_value.size}-byte key] (handle: 0x#{handle_hex})"

    digest = Bytes.new(32, 0xab_u8)
    sig = credential.sign(digest)
    verified = credential.verify(digest, sig)
    io.puts "FIDO2 ECDSA P-256 signature & verification (r: #{sig.r.size}B, s: #{sig.s.size}B): " \
            "#{verified ? "SUCCESS" : "FAILED"}"

    run_tpm2_encryption_demo(io, credential.auth_value)
  end

  private def self.run_tpm2_encryption_demo(io : IO, payload : Bytes) : Nil
    session = Crystal::Tpm2::Tss::Session.new(
      0x0200_0000_u32,
      0_u8,
      Crystal::Tpm2::Tss::TPM2::Algorithms::SHA256
    )
    session.session_key = Bytes.new(32, 0x01_u8)
    session.update_nonce_tpm(Bytes.new(32, 0x02_u8))
    session.nonce_caller = Bytes.new(32, 0x03_u8)

    xor_enc = Crystal::Tpm2::Tss::ParameterEncryption.encrypt(payload, session, "XOR")
    xor_dec = Crystal::Tpm2::Tss::ParameterEncryption.decrypt(xor_enc, session, "XOR")
    io.puts "KDFa XOR Parameter Encryption roundtrip: #{xor_dec == payload ? "SUCCESS" : "FAILED"}"

    aes_enc = Crystal::Tpm2::Tss::ParameterEncryption.encrypt(payload, session, "AES-CFB")
    aes_dec = Crystal::Tpm2::Tss::ParameterEncryption.decrypt(aes_enc, session, "AES-CFB")
    io.puts "KDFa AES-128-CFB Parameter Encryption roundtrip: #{aes_dec == payload ? "SUCCESS" : "FAILED"}"
  end

  # Demonstrates NIST FIPS 203 ML-KEM-768 key encapsulation and NIST FIPS 204
  # ML-DSA-65 digital signatures backed by libsodium guarded memory.
  def self.run_pqc_sample(io : IO = STDOUT) : Nil
    io.puts "\n[5] Testing Post-Quantum Cryptography (ML-KEM-768 & ML-DSA-65)..."
    Crystal::Pqc::Constant::Sodium.init
    run_ml_kem_demo(io)
    run_ml_dsa_demo(io)
  end

  private def self.run_ml_kem_demo(io : IO) : Nil
    kem = Crystal::Pqc::Constant::MLKEMKeyPair.generate
    begin
      encap = kem.encapsulate
      decap_secret = kem.decapsulate(encap[:ciphertext])
      matched = encap[:shared_secret].consume do |alice_ss|
        decap_secret.consume do |bob_ss|
          Crystal::Pqc::Constant::Sodium.constant_time_equal?(alice_ss, bob_ss)
        end
      end
      io.puts "NIST FIPS 203 ML-KEM-768 encapsulation roundtrip: #{matched ? "SUCCESS" : "FAILED"}"
    ensure
      kem.dispose
    end
  end

  private def self.run_ml_dsa_demo(io : IO) : Nil
    dsa = Crystal::Pqc::Constant::MLDSAKeyPair.generate
    begin
      message = "Quantum-resistant FIDO2 assertion".to_slice
      signature = dsa.sign(message)
      valid = dsa.verify(message, signature)
      io.puts "NIST FIPS 204 ML-DSA-65 signature verification (#{signature.size}B): " \
              "#{valid ? "SUCCESS" : "FAILED"}"
    ensure
      dsa.dispose
    end
  end
end

unless PROGRAM_NAME.ends_with?("spec") || PROGRAM_NAME.includes?("crystal-run-spec")
  CrystalCryptoSamples.run_samples
end
