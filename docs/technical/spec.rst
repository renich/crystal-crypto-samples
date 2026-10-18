==============================================
Crystal Crypto Samples Technical Specification
==============================================

Overview
========
This specification documents the architecture and end-to-end integration contracts demonstrated by ``crystal-crypto-samples``.

Related Documents
-----------------

* `Universal Code of Honor <CODE_OF_HONOR.rst>`__

Components Integrated
=====================

* **CBOR-FIDO**: Canonical encoding/decoding and deterministic dictionary serialization via ``Crystal::Cbor::Fido.encode`` and ``Crystal::Cbor::Fido.decode``.
* **ECC-Constant**: libsodium constant-time Ed25519 digital signatures, verification, and deterministic ``sodium_malloc`` key disposal.
* **DBus-Native**: Native UNIX socket communication, message wire format, and SASL EXTERNAL authentication with 32-character hexadecimal server GUID verification.
* **TPM2-TSS**: Hardware-bound KDF key derivation and session-based KDFa XOR parameter encryption and decryption roundtrip verification.
