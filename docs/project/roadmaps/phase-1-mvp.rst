======================================
Phase 1: Five-Shard Suite Orchestrator
======================================

- **Status**: Completed (``v0.3.0``)

Deliverables
------------

- ``[x]`` Canonical CBOR map, ``UInt64``, and IEEE 754 ``Float16`` sample (``run_cbor_sample``).
- ``[x]`` Constant-time ``Ed25519`` and ``X25519`` ECDH sample (``run_ecc_sample``).
- ``[x]`` Post-quantum ``ML-KEM-768`` and ``ML-DSA-65`` sample (``run_pqc_sample``).
- ``[x]`` Native D-Bus ``BodyCodec`` ``a{sv}`` and SASL ``EXTERNAL`` + ``Hello`` sample (``run_dbus_sample``).
- ``[x]`` TPM 2.0 persistent FIDO2 credential, real NIST P-256 verification, and KDFa ``XOR``/``AES-CFB`` sample (``run_tpm2_sample``).
