=================
Problem Statement
=================

Context & Challenge
-------------------

Cryptographic and security-critical libraries—spanning canonical CBOR serialization, constant-time classical elliptic curves, post-quantum lattice cryptography, native D-Bus IPC, and TPM 2.0 hardware key management—are typically developed in isolated repositories. Without an authoritative, continuously tested integration harness that links all shards simultaneously, subtle version incompatibilities, C linker symbol collisions (`libcrypto` vs `libsodium`), or API regressions can go undetected until production deployment.

Solution
--------

``crystal-crypto-samples`` serves as the canonical end-to-end integration harness and executable reference implementation for the entire EVALinux Crypto Suite. Every release compiles and executes live workloads across all five standalone shards in a single binary and test suite.
