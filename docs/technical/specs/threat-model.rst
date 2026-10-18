============
Threat Model
============

Requirement Mapping
-------------------

Fulfills ``[FUNC-002]``, ``[FUNC-003]``, ``[FUNC-005]``, ``[FUNC-006]``, ``[FUNC-007]`` defined in :doc:`../../functional/specs/core-requirements`.

``[TECH-005]`` Security Invariants and Threat Mitigations
---------------------------------------------------------

* **Fulfills**: ``[FUNC-002]``, ``[FUNC-003]``, ``[FUNC-005]``, ``[FUNC-006]``, ``[FUNC-007]``

``crystal-crypto-samples`` enforces production cryptographic hygiene across all demonstration and integration paths:

#. **Diagnostic Secret Redaction**: Raw derived authentication keys, session keys, and ECDH/ML-KEM shared secrets must never be formatted as hexadecimal strings or written to ``IO`` streams. Only key byte lengths, persistent NV handle identifiers, and boolean verification results are logged.
#. **Guarded Memory Lifecycle**: Classical ``Ed25519``/``X25519`` private keys, post-quantum ``ML-KEM-768``/``ML-DSA-65`` secret keys, and 32-byte ``SharedSecret`` buffers reside in ``libsodium`` ``sodium_malloc`` guarded heap allocations protected with ``PROT_READ`` page permissions. Every demonstration must invoke ``SharedSecret#consume`` and ``#dispose`` inside ``ensure`` blocks so secret pages are zeroed via ``sodium_memzero`` prior to deallocation.
#. **Constant-Time Secret Comparison**: All shared-secret agreement checks in ``run_ecc_sample``, ``run_pqc_sample``, and Phase 2 hybrid ceremonies must use ``Sodium.constant_time_equal?`` backed by ``sodium_memcmp`` rather than variable-time slice equality.
#. **ECDSA Nonce-Reuse Detection**: All TPM 2.0 FIDO2 signing ceremonies must pass through ``SignatureRTracker`` to detect and abort on duplicate ECDSA ``r`` components in :math:`\mathcal{O}(1)` time.
#. **Socket Pair Isolation**: D-Bus integration samples must execute over unnamed in-memory ``UNIXSocket.pair`` descriptors rather than binding TCP ports or mutating the host system D-Bus daemon.
