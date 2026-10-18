=================
Problem Statement
=================

Context and Challenge
---------------------

Cryptographic and security-critical libraries—spanning canonical CBOR serialization, constant-time classical elliptic curves, post-quantum lattice cryptography, native D-Bus IPC, and TPM 2.0 hardware key management—are maintained in isolated repositories. Without an authoritative, continuously verified integration harness that links all shards simultaneously, subtle version incompatibilities, C linker symbol collisions between ``libcrypto`` and ``libsodium``, and cross-shard API regressions remain undetected until downstream production integration.

Furthermore, transitioning authentication infrastructure from classical elliptic-curve primitives to NIST post-quantum algorithms requires verified reference implementations showing how classical and post-quantum primitives interoperate over canonical CBOR and D-Bus transports.

Solution
--------

``crystal-crypto-samples`` serves as the authoritative end-to-end integration harness and executable reference implementation for the entire EVALinux Crypto Suite. Every release compiles and executes live workloads across ``crystal-cbor-fido``, ``crystal-ecc-constant``, ``crystal-pqc-constant``, ``crystal-dbus-native``, and ``crystal-tpm2-tss`` inside a single binary and automated specification suite.
