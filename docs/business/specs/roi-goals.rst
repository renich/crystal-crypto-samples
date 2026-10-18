=========
ROI Goals
=========

Strategic Objectives
--------------------

#. **Zero Cross-Shard Linker Conflicts**: Continuously verify that ``crystal-cbor-fido``, ``crystal-ecc-constant``, ``crystal-pqc-constant``, ``crystal-dbus-native``, and ``crystal-tpm2-tss`` compile and link cleanly inside a single Crystal binary against ``libsodium`` and OpenSSL 3.5+ ``libcrypto`` on Fedora and Alpine Linux.
#. **Executable Reference Documentation**: Provide deterministic, side-effect-isolated reference demonstrations for every shard in the suite, covering classical constant-time cryptography, NIST FIPS 203 and FIPS 204 post-quantum cryptography, canonical CTAP2 CBOR encoding, native D-Bus wire marshaling, and TPM 2.0 FIDO2 operations.
#. **Automated CI Gatekeeper**: Detect cross-repository API drift, memory-lifecycle regressions, and static analysis violations immediately through automated GitLab CI pipelines and local quality gates.
#. **Post-Quantum Readiness Blueprint**: Establish the reference architecture for Phase 2 hybrid classical/post-quantum ceremonies and containerized D-Bus CTAP2 authenticator services.
