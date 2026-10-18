====================================================================
ADR-002: Phase 2 Hybrid PQC Ceremonies and D-Bus CTAP2 Authenticator
====================================================================

- **Status**: Accepted
- **Date**: 2026-10-18
- **Author**: Rénich Bon Ćirić
- **Traceability**: ``[FUNC-006]``, ``[FUNC-007]``, ``[TECH-005]``, ``[TECH-006]``, ``[TECH-007]``

Context
-------

Phase 1 ``v0.3.0`` established isolated demonstrations for each of the five shards in the EVALinux Crypto Suite: ``crystal-cbor-fido``, ``crystal-ecc-constant``, ``crystal-pqc-constant``, ``crystal-dbus-native``, and ``crystal-tpm2-tss``. However, production FIDO2/WebAuthn authenticators and zero-trust agents must combine these shards into unified multi-shard cryptographic ceremonies:

#. **Hybrid Classical and Post-Quantum Transitions**: During the migration to NIST FIPS 203 and FIPS 204, Relying Parties and authenticators require hybrid key encapsulation combining ``X25519`` with ``ML-KEM-768`` and composite dual signatures combining ``Ed25519`` with ``ML-DSA-65``, serialized deterministically in canonical CTAP2 CBOR.
#. **End-to-End IPC Authenticator Transport**: A realistic Linux platform authenticator receives canonical CBOR CTAP2 requests over D-Bus via ``crystal-dbus-native`` and services them using hardware-backed ``crystal-tpm2-tss`` credentials and ``crystal-pqc-constant`` lattice keys inside a rootless Podman container.

Decision
--------

We will expand ``crystal-crypto-samples`` in Phase 2 ``v0.3.1`` with two cross-shard orchestration modules and container deployment manifests:

#. Implement ``CrystalCryptoSamples.run_hybrid_pqc_sample`` fulfilling ``[FUNC-006]``, ``[TECH-005]``, and ``[TECH-006]``:

   * Encode the canonical integer-keyed CBOR public-key transcript ``{1_i64 => "EVALINUX-HYBRID-V1", 2_i64 => x25519_pub, 3_i64 => mlkem768_pub, 4_i64 => mlkem768_ct}`` into ``transcript_cbor``.
   * Combine ``X25519`` and ``ML-KEM-768`` shared secrets inside nested ``SharedSecret#consume`` blocks via ``SHA256("EVALINUX-HYBRID-KEM-V1" || x25519_ss || mlkem768_ss || transcript_cbor)``.
   * Sign ``transcript_cbor`` with both ``Ed25519`` and ``ML-DSA-65`` and serialize the dual assertion map ``{1_i64 => transcript_cbor, 2_i64 => ed25519_sig, 3_i64 => mldsa65_sig}`` in canonical CBOR.

#. Implement ``CrystalCryptoSamples.run_ctap2_dbus_sample`` and rootless Podman Quadlet packaging in ``containers/`` fulfilling ``[FUNC-007]``, ``[TECH-005]``, and ``[TECH-007]`` to verify end-to-end CTAP2 CBOR request/response marshaling over authenticated UNIX domain D-Bus connections using object path ``/org/evalinux/Ctap2Authenticator1``, interface ``org.evalinux.Ctap2Authenticator1``, method ``MakeCredential``, and D-Bus signature ``ay`` -> ``ay``.

Consequences
------------

* Every shard in the suite is tested both in isolation and in a composite 5-shard cryptographic workflow.
* Downstream applications gain a copy-pasteable blueprint for hybrid classical/PQC key agreement, dual-signature CBOR serialization, D-Bus CTAP2 service loops, and rootless Podman deployment.
