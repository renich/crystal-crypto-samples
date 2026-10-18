=================
Core Requirements
=================

Functional Contracts
--------------------

- ``[FUNC-001]`` **CBOR FIDO Sample**: ``CrystalCryptoSamples.run_cbor_sample`` MUST encode and decode a canonical CBOR map containing sorted keys, a ``UInt64`` counter, and a ``Float64`` narrowed to canonical IEEE 754 ``Float16`` (``1.5_f64`` -> ``f93e00``).
- ``[FUNC-002]`` **Classical ECC Sample**: ``CrystalCryptoSamples.run_ecc_sample`` MUST generate ``Ed25519`` signatures, perform mutual ``X25519`` ECDH key agreement using ``SharedSecret#consume`` and ``Sodium.constant_time_equal?``, and deterministically dispose of all keypairs in an ``ensure`` block.
- ``[FUNC-003]`` **Post-Quantum Cryptography Sample**: ``CrystalCryptoSamples.run_pqc_sample`` MUST execute a full NIST FIPS 203 ``ML-KEM-768`` key encapsulation/decapsulation roundtrip and a NIST FIPS 204 ``ML-DSA-65`` signature generation/verification roundtrip with deterministic disposal of guarded keys.
- ``[FUNC-004]`` **Native D-Bus Sample**: ``CrystalCryptoSamples.run_dbus_sample`` MUST validate recursive ``a{sv}`` signatures, encode and decode an ``a{sv}`` ``BodyCodec`` payload, and complete an in-memory ``UNIXSocket.pair`` SASL ``EXTERNAL`` + ``NEGOTIATE_UNIX_FD`` + ``org.freedesktop.DBus.Hello`` handshake.
- ``[FUNC-005]`` **TPM 2.0 TSS Sample**: ``CrystalCryptoSamples.run_tpm2_sample`` MUST provision a persistent FIDO2 credential via ``FIDO2CredentialManager``, sign a 32-byte digest with ``SignatureRTracker`` protection, verify the ECDSA P-256 signature via ``FIDO2Credential#verify``, and roundtrip both ``XOR`` and ``AES-128-CFB`` parameter encryption without leaking raw secret bytes to ``IO``.
