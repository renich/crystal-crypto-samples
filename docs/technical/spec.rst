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

* **CBOR-FIDO**: Canonical encoding/decoding, ``UInt64`` serialization, canonical IEEE 754 ``Float16`` narrowing, and deterministic dictionary serialization via ``Crystal::Cbor::Fido.encode`` and ``Crystal::Cbor::Fido.decode``.
* **ECC-Constant**: libsodium constant-time Ed25519 digital signatures, X25519 ECDH shared secret agreement via ``SharedSecret#consume`` and ``Sodium.constant_time_equal?``, and deterministic ``sodium_malloc`` key disposal.
* **DBus-Native**: Recursive ``SignatureValidator`` verification, native UNIX socket communication, message wire format, SASL EXTERNAL authentication with 32-character hexadecimal server GUID verification, ``NEGOTIATE_UNIX_FD`` negotiation, and ``org.freedesktop.DBus.Hello`` unique bus name assignment.
* **TPM2-TSS**: Stateful ``FIDO2CredentialManager`` NV handle persistence, ECDSA P-256 signing with ``SignatureRTracker`` nonce-reuse verification, and session-based KDFa ``XOR`` and ``AES-128-CFB`` parameter encryption and decryption roundtrip verification.
