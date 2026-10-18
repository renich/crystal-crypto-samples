===============
Getting Started
===============

Prerequisites
-------------

Install ``crystal``, ``shards``, ``openssl-devel`` version 3.5 or newer, and ``libsodium-devel`` on Fedora Linux:

.. code-block:: bash

   sudo dnf install crystal shards openssl-devel libsodium-devel

Building and Running
--------------------

.. code-block:: bash

   shards install
   make all
   ./bin/crystal-crypto-samples

Rootless Podman Container Execution
-----------------------------------

Build and execute the hardened rootless container image via ``GNUmakefile``:

.. code-block:: bash

   make containers-build
   make containers-run
