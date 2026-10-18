===============
Getting Started
===============

Prerequisites
-------------

Install ``crystal``, ``shards``, ``openssl-devel`` (>= 3.5), and ``libsodium-devel`` on Fedora Linux:

.. code-block:: bash

   sudo dnf install crystal shards openssl-devel libsodium-devel

Building & Running
------------------

.. code-block:: bash

   shards install
   make all
   ./bin/crystal-crypto-samples
