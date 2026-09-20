=========
Changelog
=========

All notable changes to this project will be documented in this file.

The format is based on `Keep a Changelog <https://keepachangelog.com/en/1.1.0/>`_,
and this project adheres to `Semantic Versioning <https://semver.org/spec/v2.0.0.html>`_.

[Unreleased]
============

[0.1.2] - 2026-09-19
====================

.. rubric:: Added

- Demonstrated native D-Bus SASL handshake authentication over in-memory UNIX domain socket pair.
- Demonstrated TPM 2.0 hardware-bound auth value derivation with KDFa XOR parameter encryption.
- Added execution guard to only run sample script directly when executed outside the test runner.

.. rubric:: Changed

- Synchronized and validated with hardened upstream cryptographic component libraries (``crystal-cbor-fido``, ``crystal-ecc-constant``, ``crystal-dbus-native``, and ``crystal-tpm2-tss``).

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
