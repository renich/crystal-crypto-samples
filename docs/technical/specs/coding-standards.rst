================
Coding Standards
================

Crystal Engineering Rules
-------------------------

- **Explicit Type Signatures**: All method arguments and return types are explicitly annotated.
- **Strict Nil Safety**: Zero usage of ``.not_nil!``.
- **Deterministic Cleanup**: All guarded cryptographic keys (``Ed25519KeyPair``, ``X25519KeyPair``, ``MLKEMKeyPair``, ``MLDSAKeyPair``) and OS socket pairs are disposed inside ``ensure`` blocks.
- **Static Analysis**: ``crystal tool format --check``, ``ameba --all``, and ``flaw scan .`` must pass with zero warnings.
