=============
User Personas
=============

Target Audience
---------------

Security and Authentication Engineers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Engineers designing FIDO2/WebAuthn authenticators, passkey managers, or zero-trust agents in Crystal require a verified reference demonstrating how canonical CBOR, classical constant-time ECC, post-quantum lattice cryptography, native D-Bus IPC, and TPM 2.0 hardware persistence interoperate without memory leaks or side-channel exposure.

Linux Distribution and Packaging Maintainers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Maintainers validating that the complete EVALinux Crypto Suite compiles cleanly, links without symbol collisions, and passes runtime verification suites against distribution ``openssl`` and ``libsodium`` packages across Fedora, RHEL, and Alpine Linux environments.

Cryptographic Auditors and QA Engineers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Auditors inspecting constant-time shared-secret handling, guarded ``sodium_malloc`` disposal guarantees, secret redaction in diagnostic logs, and bidirectional traceability between functional requirements and executable specifications.
