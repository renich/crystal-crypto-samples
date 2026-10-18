=========
Changelog
=========

All notable changes to this project will be documented in this file.

The format is based on `Keep a Changelog <https://keepachangelog.com/en/1.1.0/>`__,
and this project adheres to `Semantic Versioning <https://semver.org/spec/v2.0.0.html>`__.

[Unreleased]
============

[0.3.1] - 2026-10-18
====================

.. rubric:: Added

- Added ``CrystalCryptoSamples.run_hybrid_pqc_sample`` and ``CrystalCryptoSamples::HybridCeremony`` demonstrating a composite ``X25519 + ML-KEM-768`` SHA-256 KDF combiner (``SHA256("EVALINUX-HYBRID-KEM-V1" || x25519_ss || mlkem768_ss || transcript_cbor)``) and ``Ed25519 + ML-DSA-65`` dual signatures over canonical integer-keyed CBOR transcripts (``[FUNC-006]``, ``[TECH-005]``, ``[TECH-006]``).
- Added ``CrystalCryptoSamples.run_ctap2_dbus_sample`` and ``CrystalCryptoSamples::Ctap2DbusCeremony`` demonstrating an end-to-end D-Bus CTAP2 ``MakeCredential`` RPC (signature ``ay`` -> ``ay``) over ``/org/evalinux/Ctap2Authenticator1`` (``org.evalinux.Ctap2Authenticator1``) backed by ``Crystal::Tpm2::Tss::FIDO2CredentialManager`` and ``Crystal::Pqc::Constant::MLDSAKeyPair`` (``[FUNC-007]``, ``[TECH-005]``, ``[TECH-007]``).
- Added ``CrystalCryptoSamples.run_all`` alias executing all seven Phase 1 and Phase 2 cryptographic ceremonies.
- Added rootless Podman ``containers/Containerfile``, hardened systemd Quadlet unit ``containers/crystal-crypto-samples.container`` (``UserNS=keep-id``, ``NoNewPrivileges=true``, ``ReadOnly=true``, ``DropCapability=ALL``), ``containers/GNUmakefile``, and root ``GNUmakefile`` ``containers-build`` and ``containers-run`` targets (``[FUNC-007]``, ``[TECH-007]``).
- Added Phase 2 ``v0.3.1`` functional and technical specifications ``[FUNC-006]``, ``[FUNC-007]``, ``[TECH-006]``, and ``[TECH-007]`` plus ``ADR-002``, dependency-tracked phased roadmaps (``TASK-101``..``TASK-204``), declarative D2 diagrams in ``docs/diagrams/``, and visual identity assets in ``assets/``.

.. rubric:: Changed

- Upgraded shard dependencies to ``crystal-cbor-fido`` ``~> 0.2.2``, ``crystal-dbus-native`` ``~> 0.3.1``, ``crystal-ecc-constant`` ``~> 0.2.2``, ``crystal-pqc-constant`` ``~> 0.1.1``, and ``crystal-tpm2-tss`` ``~> 0.4.1``.

[0.3.0] - 2026-10-18
====================

.. rubric:: Added

- Added ``crystal-pqc-constant`` (``~> 0.1.0``) dependency and ``CrystalCryptoSamples.run_pqc_sample`` demonstrating NIST FIPS 203 ``ML-KEM-768`` key encapsulation/decapsulation and NIST FIPS 204 ``ML-DSA-65`` digital signature generation and verification in guarded ``libsodium`` memory.
- Expanded ``run_dbus_sample`` to demonstrate ``BodyCodec.encode`` and ``BodyCodec.decode`` roundtrip marshaling of ``a{sv}`` dictionaries with ``Variant`` values from ``crystal-dbus-native`` ``v0.3.0``.
- Expanded ``run_tpm2_sample`` to demonstrate real NIST P-256 public key coordinate retrieval via ``TPM2_ReadPublic`` and cryptographic ECDSA ``(r, s)`` verification via ``FIDO2Credential#verify`` from ``crystal-tpm2-tss`` ``v0.4.0``.
- Added full ``../init`` modular documentation architecture (``docs/business/``, ``docs/functional/``, ``docs/technical/``, ``docs/adrs/``, ``docs/project/``, ``docs/user/``), ``LICENSE-DOCS`` (GNU FDL v1.3), root ``CODE_OF_HONOR.rst``, and Sphinx ``dirhtml`` build integration.

.. rubric:: Changed

- Upgraded shard dependencies to ``crystal-cbor-fido`` ``~> 0.2.1``, ``crystal-dbus-native`` ``~> 0.3.0``, ``crystal-ecc-constant`` ``~> 0.2.1``, ``crystal-pqc-constant`` ``~> 0.1.0``, and ``crystal-tpm2-tss`` ``~> 0.4.0``.

[0.2.1] - 2026-10-18
====================

.. rubric:: Added

- Expanded ``run_cbor_sample`` to demonstrate canonical IEEE 754 ``Float16`` narrowing and ``UInt64`` serialization alongside deterministic map key sorting.
- Expanded ``run_ecc_sample`` to demonstrate constant-time ``X25519KeyPair`` ECDH shared secret agreement with ``SharedSecret#consume`` and ``Sodium.constant_time_equal?``.
- Expanded ``run_dbus_sample`` to demonstrate ``SignatureValidator.validate("a{sv}")``, ``NEGOTIATE_UNIX_FD`` negotiation, and full bus ``Hello`` registration returning a unique bus name.
- Expanded ``run_tpm2_sample`` to demonstrate stateful ``FIDO2CredentialManager`` NV handle persistence, ``FIDO2Credential#sign`` ECDSA P-256 signing with ``SignatureRTracker``, and ``ParameterEncryption`` ``AES-CFB`` roundtrip alongside ``XOR``.

[0.2.0] - 2026-10-18
====================

.. rubric:: Security

- Redacted raw derived TPM 2.0 KDF authentication key bytes from sample stdout output.
- Enforced deterministic ``ensure`` cleanup for Ed25519 keypair disposal and UNIX domain socket pairs.

.. rubric:: Fixed

- Fixed ``spec/spec_helper.cr`` require path and redirected ``CrystalCryptoSamples.run_samples`` spec output into an ``IO::Memory`` buffer so ``crystal spec`` runs silently without polluting ``STDOUT``.
- Replaced placeholder D-Bus server GUID with a specification-compliant 32-character hexadecimal GUID.
- Resolved all ``crstlint`` and ``rstcheck`` warnings across ``CONTRIBUTING.rst``, ``CHANGELOG.rst``, and ``docs/``.

.. rubric:: Changed

- Decomposed ``CrystalCryptoSamples.run_samples`` into modular ``run_cbor_sample``, ``run_ecc_sample``, ``run_dbus_sample``, and ``run_tpm2_sample`` methods with explicit ``IO`` injection and full Crystal docstrings.
- Synchronized shard dependencies to ``crystal-cbor-fido`` ``~> 0.2.0``, ``crystal-dbus-native`` ``~> 0.2.0``, ``crystal-ecc-constant`` ``~> 0.2.0``, and ``crystal-tpm2-tss`` ``~> 0.3.0``.
- Upgraded ``GNUmakefile`` with strict safety prologue, real ``bin/ameba`` and ``bin/flaw`` file targets, ``bin/crystal-crypto-samples`` binary build/install rules, and ``ameba --all`` enforcement.
- Modernized ``.gitlab-ci.yml`` with ``workflow: rules:``, caching, DAG ``needs:``, and ``$CI_DEFAULT_BRANCH``.

[0.1.2] - 2026-09-19
====================

.. rubric:: Added

- Demonstrated native D-Bus SASL handshake authentication over in-memory UNIX domain socket pair.
- Demonstrated TPM 2.0 hardware-bound auth value derivation with KDFa XOR parameter encryption.
- Added execution guard to only run sample script directly when executed outside the test runner.

.. rubric:: Changed

- Synchronized and validated with hardened upstream cryptographic component libraries: ``crystal-cbor-fido``, ``crystal-ecc-constant``, ``crystal-dbus-native``, and ``crystal-tpm2-tss``.

[0.1.1] - 2026-08-13
====================

.. rubric:: Changed

- Added ``flaw`` to development dependencies in ``shard.yml``.
- Corrected doc directory path in GNUmakefile install target.
- Synchronized with updated upstream component dependencies.

[0.1.0] - 2026-06-05
====================

.. rubric:: Added

- Initial orchestrated release of the architecture.
- Full TDD specifications with >80% code coverage.
- Code of Honor integration.
- FHS 3 compliant GNUmakefile.
- GitLab CI/CD Alpine pipeline.
