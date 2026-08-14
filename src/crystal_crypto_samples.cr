require "crystal-cbor-fido"
require "crystal-dbus-native"
require "crystal-ecc-constant"
require "crystal-tpm2-tss"
require "socket"

module CrystalCryptoSamples
  VERSION = "0.1.1"

  def self.run_samples
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
    begin
      pair = UNIXSocket.pair
      conn = Crystal::Dbus::Native::DBusConnection.new(pair.first)
      conn.start
      puts "DBus connection mocked and initialized natively."
      conn.close
    rescue e : Exception
      puts "Mock DBus setup caught: #{e.message}"
    end

    puts "\n[4] Testing TPM2 TSS Memory Structures..."
    tpm_mock = TPMDevice.new
    credential_manager = FIDO2CredentialManager.new(tpm_mock)
    auth_value = credential_manager.derive_auth_value("user-credential-1234")
    puts "Derived hardware-bound auth key: #{auth_value.hexstring[0..15]}..."

    puts "\nAll dependencies successfully compiled and executed!"
    puts "=========================================================="
  end
end

CrystalCryptoSamples.run_samples
