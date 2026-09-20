============================================
Crystal Crypto Samples Technical Specification
============================================

.. toctree::
   :maxdepth: 2
   :caption: Specifications

   CODE_OF_HONOR

Overview
========
This specification documents the architecture and end-to-end integration contracts demonstrated by ``crystal-crypto-samples``.

Components Integrated
=====================
* **CBOR-FIDO**: Canonical encoding/decoding and deterministic dictionary serialization.
* **ECC-Constant**: libsodium constant-time Ed25519 digital signatures and verification.
* **DBus-Native**: Native UNIX socket communication, message wire format, and SASL authentication.
* **TPM2-TSS**: Hardware-bound KDF key persistence and FIDO2 credential management.
