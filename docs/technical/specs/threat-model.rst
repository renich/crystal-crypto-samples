============
Threat Model
============

Security Invariants
-------------------

- **Secret Redaction**: Even in demonstration code, derived keys and shared secrets are never printed in hexadecimal to ``STDOUT``; only byte lengths and boolean equality verification results are logged.
- **Guarded Memory Lifecycle**: Classical and post-quantum secret keys are wiped and freed immediately after each demonstration finishes via ``dispose`` and ``SharedSecret#consume``.
