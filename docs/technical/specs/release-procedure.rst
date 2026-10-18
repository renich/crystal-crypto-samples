=================
Release Procedure
=================

Release Checklist
-----------------

#. Ensure all upstream shards (``crystal-cbor-fido``, ``crystal-dbus-native``, ``crystal-ecc-constant``, ``crystal-pqc-constant``, ``crystal-tpm2-tss``) are tagged and pushed to GitLab and GitHub.
#. Remove any temporary ``shard.override.yml`` and run ``shards update`` to verify resolution from upstream Git tags.
#. Execute ``make check``, ``make build``, and ``make docs``.
#. Update ``CHANGELOG.rst``, commit with ``Signed-off-by``, create a GPG-signed tag ``git tag -s vX.Y.Z``, and push to both ``gitlab`` and ``origin``.
