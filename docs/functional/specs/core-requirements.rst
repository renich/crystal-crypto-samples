=================
Core Requirements
=================

Phase 1 Baseline Requirements for v0.3.0
----------------------------------------

``[FUNC-001]`` Canonical CBOR FIDO Demonstration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``CrystalCryptoSamples.run_cbor_sample`` must encode and decode a canonical CTAP2/RFC 8949 Section 4.2 CBOR map via ``crystal-cbor-fido``. The demonstration must verify deterministic map key sorting, serialize a ``UInt64`` maximum counter ``18_446_744_073_709_551_615_u64``, narrow ``1.5_f64`` to the canonical IEEE 754 ``Float16`` byte sequence ``f93e00``, and emit deterministic verification output to the injected ``IO`` stream.

* **Fulfilled By**: ``[TECH-001]``, ``[TECH-004]`` in :doc:`../../technical/specs/architecture-overview` and :doc:`../../technical/specs/coding-standards`.

``[FUNC-002]`` Classical Constant-Time ECC Demonstration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``CrystalCryptoSamples.run_ecc_sample`` must initialize ``Crystal::Ecc::Constant::Sodium``, generate ``Ed25519`` detached signatures and verify them in constant time, and perform mutual ``X25519`` Elliptic Curve Diffie-Hellman key agreement between two ephemeral keypairs. Shared secrets must be evaluated inside ``SharedSecret#consume`` blocks using ``Sodium.constant_time_equal?``, and all keypairs must be deterministically wiped via ``#dispose`` inside ``ensure`` blocks.

* **Fulfilled By**: ``[TECH-002]``, ``[TECH-004]``, ``[TECH-005]`` in :doc:`../../technical/specs/architecture-overview`, :doc:`../../technical/specs/coding-standards`, and :doc:`../../technical/specs/threat-model`.

``[FUNC-003]`` Post-Quantum Cryptography Demonstration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``CrystalCryptoSamples.run_pqc_sample`` must initialize ``Crystal::Pqc::Constant::Sodium``, execute a full NIST FIPS 203 ``ML-KEM-768`` key encapsulation and decapsulation roundtrip inside guarded memory using ``SharedSecret#consume`` and ``Sodium.constant_time_equal?``, and execute a full NIST FIPS 204 ``ML-DSA-65`` lattice digital signature generation and verification roundtrip. All guarded ``MLKEMKeyPair`` and ``MLDSAKeyPair`` instances must be deterministically wiped via ``#dispose`` inside ``ensure`` blocks.

* **Fulfilled By**: ``[TECH-002]``, ``[TECH-004]``, ``[TECH-005]`` in :doc:`../../technical/specs/architecture-overview`, :doc:`../../technical/specs/coding-standards`, and :doc:`../../technical/specs/threat-model`.

``[FUNC-004]`` Native D-Bus Wire Protocol Demonstration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``CrystalCryptoSamples.run_dbus_sample`` must validate the recursive ``a{sv}`` type signature via ``SignatureValidator.validate("a{sv}")``, perform a ``BodyCodec.encode`` and ``BodyCodec.decode`` roundtrip of an ``a{sv}`` dictionary containing a ``Variant`` payload, and complete an in-memory ``UNIXSocket.pair`` handshake exercising SASL ``EXTERNAL`` authentication, ``NEGOTIATE_UNIX_FD`` negotiation, and ``org.freedesktop.DBus.Hello`` bus registration. Both client and server sockets must be closed deterministically inside ``ensure`` blocks.

* **Fulfilled By**: ``[TECH-001]``, ``[TECH-004]`` in :doc:`../../technical/specs/architecture-overview` and :doc:`../../technical/specs/coding-standards`.

``[FUNC-005]`` TPM 2.0 TSS and FIDO2 Demonstration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``CrystalCryptoSamples.run_tpm2_sample`` must provision a persistent FIDO2 credential via ``FIDO2CredentialManager`` with dynamic NV handle persistence, extract the public key via ``TPM2_ReadPublic`` to sign and cryptographically verify a 32-byte digest with NIST P-256 ECDSA and ``SignatureRTracker`` nonce-reuse tracking, and execute KDFa ``XOR`` and ``AES-128-CFB`` parameter encryption roundtrips. Raw derived key bytes must be redacted from ``IO`` output.

* **Fulfilled By**: ``[TECH-003]``, ``[TECH-004]``, ``[TECH-005]`` in :doc:`../../technical/specs/architecture-overview`, :doc:`../../technical/specs/coding-standards`, and :doc:`../../technical/specs/threat-model`.

Phase 2 Target Requirements for v0.3.1
--------------------------------------

``[FUNC-006]`` Hybrid Classical and Post-Quantum Cryptographic Ceremony
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The harness must provide ``CrystalCryptoSamples.run_hybrid_pqc_sample(io : IO = STDOUT) : Nil`` in Phase 2 ``v0.3.1``. It must execute a composite key encapsulation ceremony combining classical ``X25519`` ECDH from ``crystal-ecc-constant`` with post-quantum NIST FIPS 203 ``ML-KEM-768`` from ``crystal-pqc-constant``, and a dual-signature assertion combining ``Ed25519`` with NIST FIPS 204 ``ML-DSA-65``:

#. **Canonical CBOR Public-Key Transcript Schema**: Encode the integer-keyed canonical CBOR map ``{1_i64 => "EVALINUX-HYBRID-V1", 2_i64 => x25519_pub, 3_i64 => mlkem768_pub, 4_i64 => mlkem768_ct}``—where ``x25519_pub`` binds both peers' concatenated 32-byte ``X25519`` public keys—into ``transcript_cbor`` via ``Crystal::Cbor::Fido.encode``.
#. **Hybrid KDF Combiner**: Derive the 32-byte hybrid session key inside nested ``SharedSecret#consume`` blocks into a guarded ``SecureBuffer`` using the exact domain-separated SHA-256 construction ``SHA256("EVALINUX-HYBRID-KEM-V1" || x25519_ss || mlkem768_ss || transcript_cbor)`` and verify initiator/responder agreement via ``Sodium.constant_time_equal?`` without exposing raw shared secret bytes outside guarded memory.
#. **Canonical CBOR Dual-Signature Assertion Schema**: Sign ``transcript_cbor`` with both ``Ed25519KeyPair#sign`` and ``MLDSAKeyPair#sign``, encode the assertion map ``{1_i64 => transcript_cbor, 2_i64 => ed25519_sig, 3_i64 => mldsa65_sig}`` via ``Crystal::Cbor::Fido.encode``, decode it via ``Crystal::Cbor::Fido.decode``, and verify both signatures deterministically.

* **Fulfilled By**: ``[TECH-004]``, ``[TECH-005]``, ``[TECH-006]`` in :doc:`../../technical/specs/architecture-overview`, :doc:`../../technical/specs/coding-standards`, and :doc:`../../technical/specs/threat-model`.

``[FUNC-007]`` End-to-End D-Bus CTAP2 Authenticator Ceremony and Rootless Podman Packaging
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The harness must provide ``CrystalCryptoSamples.run_ctap2_dbus_sample(io : IO = STDOUT) : Nil`` and container deployment artifacts in Phase 2 ``v0.3.1``. A client fiber must serialize a canonical CBOR ``authenticatorMakeCredential`` request via ``crystal-cbor-fido``, invoke the D-Bus method ``MakeCredential`` on object path ``/org/evalinux/Ctap2Authenticator1`` and interface ``org.evalinux.Ctap2Authenticator1`` with D-Bus signature ``ay`` returning ``ay`` over an authenticated ``crystal-dbus-native`` connection, and process the request in a responder fiber backed by ``crystal-tpm2-tss`` hardware-bound NIST P-256 credentials and ``crystal-pqc-constant`` ``ML-DSA-65`` attestation signatures returning keys ``1``..``6`` (credential ID, ECDSA ``r``/``s``, ``ML-DSA-65`` signature, and NIST P-256 ``public_key_x``/``public_key_y`` coordinates). Additionally, the repository must provide a multi-stage rootless ``containers/Containerfile`` and systemd Quadlet unit following the ``../init/app`` operational blueprint.

* **Fulfilled By**: ``[TECH-004]``, ``[TECH-005]``, ``[TECH-007]`` in :doc:`../../technical/specs/architecture-overview`, :doc:`../../technical/specs/coding-standards`, and :doc:`../../technical/specs/threat-model`.
