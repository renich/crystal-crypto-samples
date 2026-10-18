=========================
Functional Specifications
=========================

This section defines the deterministic functional requirements ``[FUNC-001]`` through ``[FUNC-007]`` for ``crystal-crypto-samples`` across Phase 1 ``v0.3.0`` and Phase 2 ``v0.4.0``.

Traceability Matrix Summary
---------------------------

.. list-table::
   :widths: 18 44 20 18
   :header-rows: 1

   * - Requirement ID
     - Capability Summary
     - Technical Specs
     - Target Release
   * - ``[FUNC-001]``
     - Canonical CBOR FIDO Demonstration
     - ``[TECH-001]``, ``[TECH-004]``
     - ``v0.3.0``
   * - ``[FUNC-002]``
     - Classical Constant-Time ECC Demonstration
     - ``[TECH-002]``, ``[TECH-004]``, ``[TECH-005]``
     - ``v0.3.0``
   * - ``[FUNC-003]``
     - Post-Quantum Cryptography Demonstration
     - ``[TECH-002]``, ``[TECH-004]``, ``[TECH-005]``
     - ``v0.3.0``
   * - ``[FUNC-004]``
     - Native D-Bus Wire Protocol Demonstration
     - ``[TECH-001]``, ``[TECH-004]``
     - ``v0.3.0``
   * - ``[FUNC-005]``
     - TPM 2.0 TSS and FIDO2 Demonstration
     - ``[TECH-003]``, ``[TECH-004]``, ``[TECH-005]``
     - ``v0.3.0``
   * - ``[FUNC-006]``
     - Hybrid Classical and Post-Quantum Cryptographic Ceremony
     - ``[TECH-005]``, ``[TECH-006]``
     - ``v0.4.0``
   * - ``[FUNC-007]``
     - End-to-End D-Bus CTAP2 Authenticator Ceremony and Rootless Podman Packaging
     - ``[TECH-005]``, ``[TECH-007]``
     - ``v0.4.0``

.. toctree::
   :maxdepth: 2
   :caption: Functional Modules

   specs/core-requirements
