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
     - `Business Specifications <business/spec.rst>`__
   * - **Functional Specifications**
     - Requirements ``[FUNC-001]``..``[FUNC-005]`` covering all five shard demonstrations.
     - `Functional Specifications <functional/spec.rst>`__
   * - **Technical Architecture**
     - Orchestration flow, coding standards, threat model, and release protocol.
     - `Technical Architecture <technical/spec.rst>`__
   * - **Architecture Decisions**
     - Immutable Architecture Decision Records and trade-off analyses.
     - `Architecture Decisions <adrs/index.rst>`__
   * - **Project Roadmap**
     - Sequenced phase milestones, delivery tracking, and verification audits.
     - `Project Roadmap <project/roadmap.rst>`__
   * - **User Guides**
     - Installation, build targets, and CLI execution guide.
     - `User Manual <user/index.rst>`__
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
