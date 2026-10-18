require "crystal-cbor-fido"
require "crystal-dbus-native"
require "crystal-ecc-constant"
require "crystal-tpm2-tss"
require "socket"

# End-to-end integration harness and demonstration runner for the EVALinux
# Crystal cryptographic library suite.
module CrystalCryptoSamples
  # Current version of the `crystal-crypto-samples` integration suite.
  VERSION = "0.2.0"

  # Executes all four cryptographic integration demonstrations and writes
  # structured status output to *io*.
  def self.run_samples(io : IO = STDOUT) : Nil
    io.puts "=========================================================="
    io.puts "          EVALinux Crypto Suite - Sample App              "
    io.puts "=========================================================="

    run_cbor_sample(io)
    run_ecc_sample(io)
    run_dbus_sample(io)
    run_tpm2_sample(io)

    io.puts "\nAll dependencies successfully compiled and executed!"
    io.puts "=========================================================="
  end

  # Demonstrates canonical CTAP2/FIDO2 CBOR map encoding and decoding.
  def self.run_cbor_sample(io : IO = STDOUT) : Nil
    io.puts "\n[1] Testing CBOR FIDO Encoding..."
    data = Hash(Crystal::Cbor::Fido::Value, Crystal::Cbor::Fido::Value).new
    data["challenge"] = "rand123"
    data["user_id"] = 100_i64

    bytes = Crystal::Cbor::Fido.encode(data)
    io.puts "Encoded CBOR Payload: #{bytes.hexstring}"

    decoded = Crystal::Cbor::Fido.decode(bytes)
    io.puts "Decoded CBOR Payload: #{decoded}"
  end

  # Demonstrates constant-time Ed25519 key generation, detached signing,
  # verification, and guarded memory disposal.
  def self.run_ecc_sample(io : IO = STDOUT) : Nil
    io.puts "\n[2] Testing ECC Constant Time Signatures..."
    Crystal::Ecc::Constant::Sodium.init
    keypair = Crystal::Ecc::Constant::Ed25519KeyPair.generate
    begin
      message = "Strictly FIDO2 assertion".to_slice
      signature = keypair.sign(message)
      is_valid = Crystal::Ecc::Constant::Sodium.verify_ed25519(keypair.public_key, message, signature)
      io.puts "Signature verification: #{is_valid ? "SUCCESS" : "FAILED"}"
    ensure
      keypair.dispose
    end
  end

  # Demonstrates native D-Bus SASL EXTERNAL authentication over an in-memory
  # UNIX domain socket pair.
  def self.run_dbus_sample(io : IO = STDOUT) : Nil
    io.puts "\n[3] Testing Native DBus Structures..."
    client, server = UNIXSocket.pair(Socket::Type::STREAM)
    done = Channel(Nil).new(1)
    spawn do
      server.read_byte
      server.gets("\r\n")
      server << "OK 0123456789abcdef0123456789abcdef\r\n"
      server.flush
      server.gets("\r\n")
    ensure
      server.close
      done.send(nil)
    end

    conn = Crystal::Dbus::Native::DBusConnection.new(client)
    begin
      guid = conn.start(1000_u32, hello: false)
      io.puts "DBus connection authenticated via SASL (GUID: #{guid})."
    ensure
      conn.close
      done.receive
    end
  end

  # Demonstrates TPM 2.0 hardware-bound KDF key derivation and session-based
  # XOR parameter encryption.
  def self.run_tpm2_sample(io : IO = STDOUT) : Nil
    io.puts "\n[4] Testing TPM2 TSS Memory Structures & Parameter Encryption..."
    tpm_mock = Crystal::Tpm2::Tss::TPMDevice.new
    credential_manager = Crystal::Tpm2::Tss::FIDO2CredentialManager.new(tpm_mock)
    auth_value = credential_manager.derive_auth_value("user-credential-1234")
    io.puts "Derived hardware-bound auth key: [REDACTED #{auth_value.size}-byte key]"

    session = Crystal::Tpm2::Tss::Session.new(
      0x0200_0000_u32,
      0_u8,
      Crystal::Tpm2::Tss::TPM2::Algorithms::SHA256
    )
    session.session_key = Bytes.new(32, 0x01_u8)
    session.update_nonce_tpm(Bytes.new(32, 0x02_u8))
    session.nonce_caller = Bytes.new(32, 0x03_u8)
    encrypted = Crystal::Tpm2::Tss::ParameterEncryption.encrypt(auth_value, session, "XOR")
    decrypted = Crystal::Tpm2::Tss::ParameterEncryption.decrypt(encrypted, session, "XOR")
    io.puts "KDFa XOR Parameter Encryption roundtrip: #{decrypted == auth_value ? "SUCCESS" : "FAILED"}"
  end
end

unless PROGRAM_NAME.ends_with?("spec") || PROGRAM_NAME.includes?("crystal-run-spec")
  CrystalCryptoSamples.run_samples
end
