=================
Release Procedure
=================

Requirement Mapping
-------------------

Fulfills ``[FUNC-001]``, ``[FUNC-002]``, ``[FUNC-003]``, ``[FUNC-004]``, ``[FUNC-005]`` defined in :doc:`../../functional/specs/core-requirements`.

Release Engineering Checklist
-----------------------------

#. Verify that all five upstream shards—``crystal-cbor-fido``, ``crystal-dbus-native``, ``crystal-ecc-constant``, ``crystal-pqc-constant``, and ``crystal-tpm2-tss``—are tagged with GPG-signed semantic version tags and pushed to both GitLab and GitHub.
#. Ensure ``shard.yml`` pins the exact target minor release series for all five shards, remove any local ``shard.override.yml``, and execute ``shards install`` to verify clean dependency resolution from upstream Git tags.
#. Execute the full verification gate:

   .. code-block:: bash

      make check
      make build
      make docs

#. Update ``CHANGELOG.rst`` under the new version heading following `Keep a Changelog 1.1.0 <https://keepachangelog.com/en/1.1.0/>`__ and `Semantic Versioning 2.0.0 <https://semver.org/spec/v2.0.0.html>`__.
#. Commit the release metadata with ``Signed-off-by``, create a GPG-signed annotated tag ``git tag -s vX.Y.Z -m "Release vX.Y.Z"``, and push the branch and tag to both ``gitlab`` and ``origin``.
