====================================
crystal-crypto-samples Documentation
====================================

**End-to-End Integration Harness and Demonstration Suite for the EVALinux Crypto Suite.**

Welcome to the official documentation portal for ``crystal-crypto-samples``. This application integrates and verifies all five standalone cryptographic and IPC shards: ``crystal-cbor-fido``, ``crystal-ecc-constant``, ``crystal-pqc-constant``, ``crystal-dbus-native``, and ``crystal-tpm2-tss``.

Documentation Architecture
--------------------------

.. list-table::
   :widths: 25 45 30
   :header-rows: 1

   * - Guide
     - Purpose & Scope
     - Entrypoint
   * - **Business & Strategy**
     - Cross-shard integration vision, ecosystem validation goals, and user personas.
     - :doc:`Business Specifications <business/spec>`
   * - **Functional Specifications**
     - Requirements ``[FUNC-001]``..``[FUNC-007]`` covering all five shard demonstrations and Phase 2 hybrid ceremonies.
     - :doc:`Functional Specifications <functional/spec>`
   * - **Technical Architecture**
     - Specifications ``[TECH-001]``..``[TECH-007]``, D2 topology, coding standards, threat model, and release protocol.
     - :doc:`Technical Architecture <technical/spec>`
   * - **Architecture Decisions**
     - Immutable Architecture Decision Records and trade-off analyses.
     - :doc:`Architecture Decisions <adrs/index>`
   * - **Project Roadmap**
     - Sequenced phase milestones, ``TASK-101``..``TASK-204`` critical paths, and verification audits.
     - :doc:`Project Roadmap <project/roadmap>`
   * - **User Guides**
     - Installation, build targets, and CLI execution guide.
     - :doc:`User Manual <user/index>`
   * - **Crystal API Reference**
     - Compiler-generated API documentation for ``CrystalCryptoSamples``.
     - `Crystal API Reference <technical/api/index.html>`__

.. toctree::
   :maxdepth: 2
   :caption: Documentation Suite

   business/spec
   functional/spec
   technical/spec
   adrs/index
   project/roadmap
   user/index

Indices and tables
------------------

* :ref:`genindex`
* :ref:`search`
