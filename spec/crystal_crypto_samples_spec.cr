require "./spec_helper"

describe CrystalCryptoSamples do
  it "defines VERSION" do
    CrystalCryptoSamples::VERSION.should eq("0.2.1")
  end

  it "executes CBOR FIDO sample and verifies canonical Float16, UInt64, and map roundtrip output" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_cbor_sample(io)
    output = io.to_s
    output.should contain("[1] Testing CBOR FIDO Encoding...")
    output.should contain("Encoded CBOR Payload:")
    output.should contain("Canonical Float16 (1.5): f93e00")
    output.should contain("Decoded CBOR Payload:")
    output.should contain("rand123")
    output.should contain("18446744073709551615")
  end

  it "executes ECC constant-time signature and X25519 ECDH samples" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_ecc_sample(io)
    output = io.to_s
    output.should contain("[2] Testing ECC Constant Time Signatures & X25519 ECDH...")
    output.should contain("Signature verification: SUCCESS")
    output.should contain("X25519 ECDH shared secret agreement: SUCCESS")
  end

  it "executes native D-Bus SASL, UNIX FD negotiation, and bus Hello sample" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_dbus_sample(io)
    output = io.to_s
    output.should contain("[3] Testing Native DBus Structures...")
    output.should contain("Signature validation (a{sv}): VALID")
    expected_dbus = "DBus connection authenticated via SASL " \
                    "(GUID: 0123456789abcdef0123456789abcdef, unique_name: :1.42, unix_fds: true)."
    output.should contain(expected_dbus)
  end

  it "executes TPM2 TSS sample with FIDO2 ECDSA signing and XOR + AES-128-CFB encryption roundtrips" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_tpm2_sample(io)
    output = io.to_s
    output.should contain("[4] Testing TPM2 TSS Memory Structures & Parameter Encryption...")
    output.should contain("Derived hardware-bound auth key: [REDACTED 32-byte key] (handle: 0x81010001)")
    output.should contain("FIDO2 ECDSA signature generated (r: 32B, s: 32B): SUCCESS")
    output.should contain("KDFa XOR Parameter Encryption roundtrip: SUCCESS")
    output.should contain("KDFa AES-128-CFB Parameter Encryption roundtrip: SUCCESS")
  end

  it "executes the full sample suite end-to-end without polluting STDOUT" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_samples(io)
    output = io.to_s
    output.should contain("EVALinux Crypto Suite - Sample App")
    output.should contain("All dependencies successfully compiled and executed!")
  end
end
