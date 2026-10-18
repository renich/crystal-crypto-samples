require "openssl"

module CrystalCryptoSamples
  # Orchestrates the Phase 2 hybrid classical (`X25519` + `Ed25519`) and
  # post-quantum (`ML-KEM-768` + `ML-DSA-65`) canonical CBOR ceremony.
  module HybridCeremony
    # Canonical domain-separation context string for the hybrid transcript.
    TRANSCRIPT_LABEL = "EVALINUX-HYBRID-V1"

    # Canonical domain-separation prefix for the SHA-256 hybrid KDF combiner.
    KDF_DOMAIN_LABEL = "EVALINUX-HYBRID-KEM-V1"

    # Executes the complete hybrid KEM KDF and dual-signature CBOR ceremony.
    def self.run(io : IO = STDOUT) : Nil
      io.puts "\n[6] Testing Hybrid Classical-PQC Ceremony (X25519 + ML-KEM-768 & Ed25519 + ML-DSA-65)..."
      Crystal::Ecc::Constant::Sodium.init
      Crystal::Pqc::Constant::Sodium.init

      transcript_cbor, kdf_ok = execute_hybrid_kem
      io.puts "Hybrid X25519 + ML-KEM-768 KDF session key agreement (32B): #{kdf_ok ? "SUCCESS" : "FAILED"}"

      sig_ok = execute_dual_signatures(transcript_cbor)
      io.puts "Hybrid Ed25519 (64B) + ML-DSA-65 (3309B) CBOR assertion verification: " \
              "#{sig_ok ? "SUCCESS" : "FAILED"}"
    end

    private def self.execute_hybrid_kem : Tuple(Bytes, Bool)
      alice_x = Crystal::Ecc::Constant::X25519KeyPair.generate
      bob_x = Crystal::Ecc::Constant::X25519KeyPair.generate
      kem = Crystal::Pqc::Constant::MLKEMKeyPair.generate
      begin
        encap = kem.encapsulate
        decap_secret = kem.decapsulate(encap[:ciphertext])
        x25519_pubs = combine_public_keys(alice_x.public_key.bytes, bob_x.public_key.bytes)
        transcript_cbor = encode_transcript(x25519_pubs, kem.public_key, encap[:ciphertext])
        agreed = compare_hybrid_keys(alice_x, bob_x, encap[:shared_secret], decap_secret, transcript_cbor)
        {transcript_cbor, agreed}
      ensure
        alice_x.dispose
        bob_x.dispose
        kem.dispose
      end
    end

    private def self.combine_public_keys(initiator_pub : Bytes, responder_pub : Bytes) : Bytes
      combined = Bytes.new(initiator_pub.size + responder_pub.size)
      initiator_pub.copy_to(combined)
      responder_pub.copy_to(combined + initiator_pub.size)
      combined
    end

    # Encodes the canonical integer-keyed CBOR public-key transcript map.
    def self.encode_transcript(x25519_pub : Bytes, mlkem_pub : Bytes, mlkem_ct : Bytes) : Bytes
      map = Hash(Crystal::Cbor::Fido::Value, Crystal::Cbor::Fido::Value).new
      map[1_i64] = TRANSCRIPT_LABEL
      map[2_i64] = x25519_pub
      map[3_i64] = mlkem_pub
      map[4_i64] = mlkem_ct
      Crystal::Cbor::Fido.encode(map)
    end

    private def self.compare_hybrid_keys(
      alice_x : Crystal::Ecc::Constant::X25519KeyPair,
      bob_x : Crystal::Ecc::Constant::X25519KeyPair,
      encap_ss : Crystal::Pqc::Constant::SharedSecret,
      decap_ss : Crystal::Pqc::Constant::SharedSecret,
      transcript_cbor : Bytes,
    ) : Bool
      alice_x.diffie_hellman(bob_x.public_key).consume do |alice_ecdh|
        encap_ss.consume do |alice_kem|
          initiator_key = derive_hybrid_key(alice_ecdh, alice_kem, transcript_cbor)
          begin
            verify_responder_key(bob_x, alice_x.public_key, decap_ss, transcript_cbor, initiator_key)
          ensure
            initiator_key.dispose
          end
        end
      end
    end

    private def self.verify_responder_key(
      bob_x : Crystal::Ecc::Constant::X25519KeyPair,
      alice_pub : Crystal::Ecc::Constant::PublicKey,
      decap_ss : Crystal::Pqc::Constant::SharedSecret,
      transcript_cbor : Bytes,
      initiator_key : Crystal::Ecc::Constant::SecureBuffer,
    ) : Bool
      bob_x.diffie_hellman(alice_pub).consume do |bob_ecdh|
        decap_ss.consume do |bob_kem|
          responder_key = derive_hybrid_key(bob_ecdh, bob_kem, transcript_cbor)
          begin
            initiator_key.with_bytes do |init_bytes|
              responder_key.with_bytes do |resp_bytes|
                Crystal::Ecc::Constant::Sodium.constant_time_equal?(init_bytes, resp_bytes)
              end
            end
          ensure
            responder_key.dispose
          end
        end
      end
    end

    private def self.derive_hybrid_key(
      x25519_ss : Bytes,
      mlkem768_ss : Bytes,
      transcript_cbor : Bytes,
    ) : Crystal::Ecc::Constant::SecureBuffer
      digest = OpenSSL::Digest.new("SHA256")
      digest.update(KDF_DOMAIN_LABEL.to_slice)
      digest.update(x25519_ss)
      digest.update(mlkem768_ss)
      digest.update(transcript_cbor)
      raw = digest.final
      begin
        Crystal::Ecc::Constant::SecureBuffer.from_bytes(raw)
      ensure
        raw.fill(0_u8)
      end
    end

    private def self.execute_dual_signatures(transcript_cbor : Bytes) : Bool
      ed = Crystal::Ecc::Constant::Ed25519KeyPair.generate
      dsa = Crystal::Pqc::Constant::MLDSAKeyPair.generate
      begin
        ctx = TRANSCRIPT_LABEL.to_slice
        ed_sig = ed.sign(transcript_cbor).bytes
        dsa_sig = dsa.sign(transcript_cbor, ctx)
        assertion_cbor = encode_assertion(transcript_cbor, ed_sig, dsa_sig)
        verify_decoded_assertion(assertion_cbor, ed, dsa, ctx)
      ensure
        ed.dispose
        dsa.dispose
      end
    end

    # Encodes the canonical integer-keyed CBOR dual-signature assertion map.
    def self.encode_assertion(transcript_cbor : Bytes, ed_sig : Bytes, dsa_sig : Bytes) : Bytes
      map = Hash(Crystal::Cbor::Fido::Value, Crystal::Cbor::Fido::Value).new
      map[1_i64] = transcript_cbor
      map[2_i64] = ed_sig
      map[3_i64] = dsa_sig
      Crystal::Cbor::Fido.encode(map)
    end

    # Decodes a canonical CBOR dual-signature assertion map and verifies both
    # the classical `Ed25519` and post-quantum `ML-DSA-65` signatures.
    def self.verify_decoded_assertion(
      assertion_cbor : Bytes,
      ed : Crystal::Ecc::Constant::Ed25519KeyPair,
      dsa : Crystal::Pqc::Constant::MLDSAKeyPair,
      ctx : Bytes = TRANSCRIPT_LABEL.to_slice,
    ) : Bool
      decoded = Crystal::Cbor::Fido.decode(assertion_cbor)
      return false unless decoded.is_a?(Hash)

      transcript = decoded[1_i64]?
      ed_sig = decoded[2_i64]?
      dsa_sig = decoded[3_i64]?
      return false unless transcript.is_a?(Bytes) && ed_sig.is_a?(Bytes) && dsa_sig.is_a?(Bytes)
      return false unless ed_sig.size == 64

      sig_obj = Crystal::Ecc::Constant::Signature.new(ed_sig)
      ed.verify(transcript, sig_obj) && dsa.verify(transcript, dsa_sig, context: ctx)
    end
  end
end
