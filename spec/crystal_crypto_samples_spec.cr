require "./spec_helper"

# Verifies [FUNC-001]..[FUNC-007] / [TECH-001]..[TECH-007]
describe CrystalCryptoSamples do
  it "defines VERSION 0.3.1" do
    CrystalCryptoSamples::VERSION.should eq("0.3.1")
  end

  # Verifies [FUNC-001] / [TECH-001]
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

  # Verifies [FUNC-002] / [TECH-002] / [TECH-005]
  it "executes ECC constant-time signature and X25519 ECDH samples" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_ecc_sample(io)
    output = io.to_s
    output.should contain("[2] Testing ECC Constant Time Signatures & X25519 ECDH...")
    output.should contain("Signature verification: SUCCESS")
    output.should contain("X25519 ECDH shared secret agreement: SUCCESS")
  end

  # Verifies [FUNC-004] / [TECH-001]
  it "executes native D-Bus BodyCodec, SASL, UNIX FD negotiation, and bus Hello sample" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_dbus_sample(io)
    output = io.to_s
    output.should contain("[3] Testing Native DBus Structures...")
    output.should contain("Signature validation (a{sv}): VALID")
    output.should contain("DBus BodyCodec (a{sv}) roundtrip: SUCCESS")
    expected_dbus = "DBus connection authenticated via SASL " \
                    "(GUID: 0123456789abcdef0123456789abcdef, unique_name: :1.42, unix_fds: true)."
    output.should contain(expected_dbus)
  end

  # Verifies [FUNC-005] / [TECH-003] / [TECH-005]
  it "executes TPM2 TSS sample with FIDO2 ECDSA P-256 verification and XOR + AES-128-CFB encryption roundtrips" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_tpm2_sample(io)
    output = io.to_s
    output.should contain("[4] Testing TPM2 TSS Memory Structures & Parameter Encryption...")
    output.should contain("Derived hardware-bound auth key: [REDACTED 32-byte key] (handle: 0x8101")
    output.should contain("FIDO2 ECDSA P-256 signature & verification (r: 32B, s: 32B): SUCCESS")
    output.should contain("KDFa XOR Parameter Encryption roundtrip: SUCCESS")
    output.should contain("KDFa AES-128-CFB Parameter Encryption roundtrip: SUCCESS")
  end

  # Verifies [FUNC-003] / [TECH-002] / [TECH-005]
  it "executes Post-Quantum Cryptography (ML-KEM-768 and ML-DSA-65) sample" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_pqc_sample(io)
    output = io.to_s
    output.should contain("[5] Testing Post-Quantum Cryptography (ML-KEM-768 & ML-DSA-65)...")
    output.should contain("NIST FIPS 203 ML-KEM-768 encapsulation roundtrip: SUCCESS")
    output.should contain("NIST FIPS 204 ML-DSA-65 signature verification (3309B): SUCCESS")
  end

  # Verifies [FUNC-006] / [TECH-005] / [TECH-006]
  it "executes Hybrid X25519 + ML-KEM-768 and Ed25519 + ML-DSA-65 canonical CBOR ceremony" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_hybrid_pqc_sample(io)
    output = io.to_s
    output.should contain("[6] Testing Hybrid Classical-PQC Ceremony (X25519 + ML-KEM-768 & Ed25519 + ML-DSA-65)...")
    output.should contain("Hybrid X25519 + ML-KEM-768 KDF session key agreement (32B): SUCCESS")
    output.should contain("Hybrid Ed25519 (64B) + ML-DSA-65 (3309B) CBOR assertion verification: SUCCESS")
    output.should_not contain("EVALINUX-HYBRID-KEM-V1".to_slice.hexstring)
  end

  # Verifies [FUNC-006] / [TECH-005] / [TECH-006]
  it "rejects tampered transcript or signature bytes in HybridCeremony.verify_decoded_assertion" do
    Crystal::Ecc::Constant::Sodium.init
    Crystal::Pqc::Constant::Sodium.init
    ed = Crystal::Ecc::Constant::Ed25519KeyPair.generate
    dsa = Crystal::Pqc::Constant::MLDSAKeyPair.generate
    begin
      ctx = CrystalCryptoSamples::HybridCeremony::TRANSCRIPT_LABEL.to_slice
      transcript = CrystalCryptoSamples::HybridCeremony.encode_transcript(
        Bytes.new(64, 0x11_u8), Bytes.new(32, 0x22_u8), Bytes.new(32, 0x33_u8)
      )
      ed_sig = ed.sign(transcript).bytes
      dsa_sig = dsa.sign(transcript, ctx)
      valid_cbor = CrystalCryptoSamples::HybridCeremony.encode_assertion(transcript, ed_sig, dsa_sig)
      CrystalCryptoSamples::HybridCeremony.verify_decoded_assertion(valid_cbor, ed, dsa, ctx).should be_true

      bad_ed = ed_sig.dup
      bad_ed[0] ^= 0xff_u8
      bad_cbor = CrystalCryptoSamples::HybridCeremony.encode_assertion(transcript, bad_ed, dsa_sig)
      CrystalCryptoSamples::HybridCeremony.verify_decoded_assertion(bad_cbor, ed, dsa, ctx).should be_false
    ensure
      ed.dispose
      dsa.dispose
    end
  end

  # Verifies [FUNC-007] / [TECH-005] / [TECH-007]
  it "executes end-to-end D-Bus CTAP2 authenticator MakeCredential ceremony over ay transport" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_ctap2_dbus_sample(io)
    output = io.to_s
    output.should contain("[7] Testing End-to-End D-Bus CTAP2 Authenticator Ceremony...")
    output.should contain("CTAP2 D-Bus MakeCredential (/org/evalinux/Ctap2Authenticator1, ay -> ay): SUCCESS")
    output.should contain("CTAP2 TPM2 P-256 (64B) + ML-DSA-65 (3309B) dual attestation verification: SUCCESS")
  end

  # Verifies [FUNC-007] / [TECH-005] / [TECH-007]
  it "rejects tampered challenge or signature bytes in Ctap2DbusCeremony.verify_response" do
    Crystal::Pqc::Constant::Sodium.init
    tpm_device = Crystal::Tpm2::Tss::TPMDevice.new
    cred_manager = Crystal::Tpm2::Tss::FIDO2CredentialManager.new(tpm_device)
    dsa = Crystal::Pqc::Constant::MLDSAKeyPair.generate
    begin
      challenge = Bytes.new(32, 0x5a_u8)
      req_cbor = CrystalCryptoSamples::Ctap2DbusCeremony.encode_request(challenge)
      resp_cbor = CrystalCryptoSamples::Ctap2DbusCeremony.process_make_credential(req_cbor, cred_manager, dsa)
      CrystalCryptoSamples::Ctap2DbusCeremony.verify_response(resp_cbor, challenge, dsa).should be_true

      bad_challenge = Bytes.new(32, 0x5b_u8)
      CrystalCryptoSamples::Ctap2DbusCeremony.verify_response(resp_cbor, bad_challenge, dsa).should be_false
    ensure
      dsa.dispose
    end
  end

  # Verifies [FUNC-001]..[FUNC-007] / [TECH-001]..[TECH-007]
  it "executes the full sample suite end-to-end via run_samples and run_all without polluting STDOUT" do
    io = IO::Memory.new
    CrystalCryptoSamples.run_all(io)
    output = io.to_s
    output.should contain("EVALinux Crypto Suite - Sample App")
    output.should contain("[6] Testing Hybrid Classical-PQC Ceremony")
    output.should contain("[7] Testing End-to-End D-Bus CTAP2 Authenticator Ceremony")
    output.should contain("All dependencies successfully compiled and executed!")
  end
end
