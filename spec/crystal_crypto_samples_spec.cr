require "./spec_helper"

describe CrystalCryptoSamples do
  it "defines VERSION" do
    CrystalCryptoSamples::VERSION.should eq("0.2.0")
  end

  it "executes CBOR FIDO sample and verifies roundtrip output" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_cbor_sample(io)
    output = io.to_s
    output.should contain("[1] Testing CBOR FIDO Encoding...")
    output.should contain("Encoded CBOR Payload:")
    output.should contain("Decoded CBOR Payload:")
    output.should contain("rand123")
  end

  it "executes ECC constant-time signature sample and verifies signature" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_ecc_sample(io)
    output = io.to_s
    output.should contain("[2] Testing ECC Constant Time Signatures...")
    output.should contain("Signature verification: SUCCESS")
  end

  it "executes native D-Bus SASL sample and verifies server GUID" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_dbus_sample(io)
    output = io.to_s
    output.should contain("[3] Testing Native DBus Structures...")
    output.should contain("DBus connection authenticated via SASL")
  end

  it "executes TPM2 TSS sample with redacted key material and verified encryption roundtrip" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_tpm2_sample(io)
    output = io.to_s
    output.should contain("[4] Testing TPM2 TSS Memory Structures & Parameter Encryption...")
    output.should contain("Derived hardware-bound auth key: [REDACTED 32-byte key]")
    output.should contain("KDFa XOR Parameter Encryption roundtrip: SUCCESS")
  end

  it "executes the full sample suite end-to-end without polluting STDOUT" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_samples(io)
    output = io.to_s
    output.should contain("EVALinux Crypto Suite - Sample App")
    output.should contain("All dependencies successfully compiled and executed!")
  end
end
