======================================
Contributing to crystal-crypto-samples
======================================

Thank you for your interest in contributing to the ``crystal-crypto-samples`` integration harness for the EVALinux Crypto Suite. We welcome contributions from human engineers and autonomous agents who share our commitment to software excellence, cryptographic rigor, and empirical verification.

Code of Honor
=============

All contributors must uphold the principles defined in `CODE_OF_HONOR.rst <CODE_OF_HONOR.rst>`__. We build resilient, well-tested software, demand intellectual honesty, operate transparently, and verify all cryptographic and system properties empirically.

Development Workflow
====================

Prerequisites
-------------

* `Crystal <https://crystal-lang.org/>`__ version 1.21.0 or newer
* `GNU Make <https://www.gnu.org/software/make/>`__
* `OpenSSL <https://www.openssl.org/>`__ version 3.5 or newer and `libsodium <https://doc.libsodium.org/>`__
* `cRSTLint <https://gitlab.com/renich/crstlint>`__ and ``rstcheck`` for documentation linting

Setting Up the Workspace
------------------------

#. Clone the repository:

   .. code-block:: bash

      git clone git@gitlab.com:renich/crystal-crypto-samples.git
      cd crystal-crypto-samples

#. Install shard dependencies:

   .. code-block:: bash

      shards install

#. Verify the test suite, static analysis, and documentation gates:

   .. code-block:: bash

      make check

Testing and Quality Standards
=============================

We adhere strictly to Test-Driven Development and the principle of **Do Not Assume; Always Verify**.

Running Checks
--------------

* **Run test suite**:

   .. code-block:: bash

      make test

* **Run static linters** including Ameba and Flaw:

   .. code-block:: bash

      make lint

* **Validate RST Documentation**:

   .. code-block:: bash

      make doc-check

Git Commit Standards
====================

We enforce the Conventional Commits specification:

* ``feat(pqc): add hybrid X25519 and ML-KEM-768 CBOR sample``
* ``fix(dbus): close UNIXSocket pair inside ensure block``
* ``docs(adrs): record decision on Phase 2 CTAP2 D-Bus ceremony``
* ``test(spec): assert IO::Memory transcript for TPM2 sample``

All commits must include a ``Signed-off-by`` trailer and be authored with full technical ownership.
