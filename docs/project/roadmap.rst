=============================================
Crystal Crypto Samples Project Master Roadmap
=============================================

Executive Summary
=================

This document outlines the phased engineering milestones and release lifecycle for ``crystal-crypto-samples``, demonstrating end-to-end integration across the EVALinux Crystal cryptographic library suite.

Roadmap Documents
-----------------

* `Phase 1: Crypto Suite End-to-End Sample Runner MVP <roadmaps/phase-1-mvp.rst>`__
* `Phase 2: Crucible Protocol Refactoring & Release Stabilization <roadmaps/phase-2-release.rst>`__

Phase Breakdown
===============

* **Phase 1 — MVP Baseline**: Sample runner orchestrating CBOR-FIDO encoding/decoding, libsodium Ed25519 signatures, D-Bus UNIX socket connection, and TPM2 KDF derivation.
* **Phase 2 — Crucible Refactoring & Release Stabilization**: Modernized dependencies, resolved static analysis linter alerts, added GPLv3 licensing, and ``v0.1.1``/``v0.1.2`` production releases.
* **Phase 3 — Echelon and Crucible v0.2.0 Hardening**: Modularized component sample methods with ``IO`` stream injection, redacted secret key material from output, verified KDFa parameter encryption/decryption roundtrip, and streamlined CI/CD execution.
