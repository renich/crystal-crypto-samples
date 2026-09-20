require "crystal-cbor-fido"
require "crystal-dbus-native"
require "crystal-ecc-constant"
require "crystal-tpm2-tss"
require "socket"

module CrystalCryptoSamples
  VERSION = "0.1.1"

  def self.run_samples : Nil
    puts "=========================================================="
    puts "          EVALinux Crypto Suite - Sample App              "
    puts "=========================================================="

    puts "\n[1] Testing CBOR FIDO Encoding..."
    io = IO::Memory.new
    encoder = Crystal::Cbor::Fido::Encoder.new(io)
    data = {} of Crystal::Cbor::Fido::Value => Crystal::Cbor::Fido::Value
    data["challenge"] = "rand123"
    data["user_id"] = 100_i64
    encoder.encode(data)
    bytes = io.to_slice
    puts "Encoded CBOR Payload: #{bytes.hexstring}"

    decoder = Crystal::Cbor::Fido::Decoder.new(IO::Memory.new(bytes))
    decoded = decoder.decode
    puts "Decoded CBOR Payload: #{decoded}"

    puts "\n[2] Testing ECC Constant Time Signatures..."
    Crystal::Ecc::Constant::Sodium.init
    keypair = Crystal::Ecc::Constant::Ed25519KeyPair.generate
    message = "Strictly FIDO2 assertion".to_slice
    signature = keypair.sign(message)
    is_valid = Crystal::Ecc::Constant::Sodium.verify_ed25519(keypair.public_key, message, signature)
    puts "Signature verification: #{is_valid ? "SUCCESS" : "FAILED"}"
    keypair.dispose

    puts "\n[3] Testing Native DBus Structures..."
    client, server = UNIXSocket.pair(Socket::Type::STREAM)
    spawn do
      server.read_byte
      server.gets("\r\n")
      server << "OK dbus_guid_12345\r\n"
      server.flush
      server.gets("\r\n")
      server.close
    end
    conn = Crystal::Dbus::Native::DBusConnection.new(client)
    guid = conn.start(1000_u32, hello: false)
    puts "DBus connection authenticated via SASL (GUID: #{guid})."
    conn.close

    puts "\n[4] Testing TPM2 TSS Memory Structures & Parameter Encryption..."
    tpm_mock = Crystal::Tpm2::Tss::TPMDevice.new
    credential_manager = Crystal::Tpm2::Tss::FIDO2CredentialManager.new(tpm_mock)
    auth_value = credential_manager.derive_auth_value("user-credential-1234")
    puts "Derived hardware-bound auth key: #{auth_value.hexstring[0..15]}..."

    session = Crystal::Tpm2::Tss::Session.new(0x02000000_u32, 0_u8, Crystal::Tpm2::Tss::TPM2::Algorithms::SHA256)
    session.session_key = Bytes.new(32, 0x01_u8)
    session.update_nonce_tpm(Bytes.new(32, 0x02_u8))
    session.nonce_caller = Bytes.new(32, 0x03_u8)
    encrypted = Crystal::Tpm2::Tss::ParameterEncryption.encrypt(auth_value, session, "XOR")
    puts "KDFa XOR Encrypted parameter: #{encrypted.hexstring[0..15]}..."

    puts "\nAll dependencies successfully compiled and executed!"
    puts "=========================================================="
  end
end

unless PROGRAM_NAME.ends_with?("spec") || PROGRAM_NAME.ends_with?("spec.tmp")
  CrystalCryptoSamples.run_samples
end
