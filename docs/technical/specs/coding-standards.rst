================
Coding Standards
================

Requirement Mapping
-------------------

Fulfills ``[FUNC-001]``, ``[FUNC-002]``, ``[FUNC-003]``, ``[FUNC-004]``, ``[FUNC-005]``, ``[FUNC-006]``, ``[FUNC-007]`` defined in :doc:`../../functional/specs/core-requirements`.

``[TECH-004]`` Crystal Engineering and Static Analysis Standards
----------------------------------------------------------------

* **Fulfills**: ``[FUNC-001]``, ``[FUNC-002]``, ``[FUNC-003]``, ``[FUNC-004]``, ``[FUNC-005]``, ``[FUNC-006]``, ``[FUNC-007]``

All source files in ``src/`` and specification files in ``spec/`` must adhere to the following engineering invariants:

#. **Explicit Type Signatures**: All module methods, private helpers, and return values must carry explicit Crystal type annotations.
#. **Strict Nil Safety**: Unsafe ``.not_nil!`` assertions and C pointer casts outside guarded shard APIs are forbidden.
#. **Deterministic Resource Disposal**: Every guarded cryptographic keypair—``Ed25519KeyPair``, ``X25519KeyPair``, ``MLKEMKeyPair``, and ``MLDSAKeyPair``—and every ``UNIXSocket`` endpoint must be released inside an ``ensure`` block.
#. **Stream-Injected Testability**: Demonstration routines must write exclusively to their injected ``io : IO`` parameter and never reference global ``STDOUT`` directly inside method bodies.
#. **Zero-Warning Static Analysis**: ``crystal tool format --check src spec``, ``./bin/ameba --all``, and ``./bin/flaw scan .`` must pass with zero warnings and zero inline suppression directives.
