====================================================
ADR-001: Unified Five-Shard Integration Architecture
====================================================

- **Status**: Accepted
- **Date**: 2026-10-18
- **Author**: Rénich Bon Ćirić

Context
-------

The EVALinux Crypto Suite comprises five standalone shards: ``crystal-cbor-fido``, ``crystal-ecc-constant``, ``crystal-pqc-constant``, ``crystal-dbus-native``, and ``crystal-tpm2-tss``. We needed a deterministic mechanism to validate that all five shards link together cleanly and expose ergonomic, mutually compatible APIs.

Decision
--------

Maintain ``crystal-crypto-samples`` as an executable harness where each shard has a dedicated ``run_*_sample(io : IO)`` method exercised both from the CLI binary and from ``crystal spec`` via ``IO::Memory``.

Consequences
------------

- Any C symbol collision or Crystal type conflict across the five shards is caught immediately by ``make all``.
- Developers gain a single runnable reference showing classical ECC, post-quantum lattice cryptography, canonical CBOR, D-Bus IPC, and TPM 2.0 working side by side.
