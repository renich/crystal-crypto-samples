=====================
Architecture Overview
=====================

Module Design
-------------

``CrystalCryptoSamples`` is structured into composable, side-effect-isolated demonstration methods in ``src/crystal_crypto_samples.cr``:

#. ``run_cbor_sample(io : IO = STDOUT) : Nil``
#. ``run_ecc_sample(io : IO = STDOUT) : Nil``
#. ``run_pqc_sample(io : IO = STDOUT) : Nil``
#. ``run_dbus_sample(io : IO = STDOUT) : Nil``
#. ``run_tpm2_sample(io : IO = STDOUT) : Nil``
#. ``run_samples(io : IO = STDOUT) : Bool``

Every method accepts an explicit ``IO`` stream parameter so that unit tests in ``spec/crystal_crypto_samples_spec.cr`` capture and assert on exact output lines via ``IO::Memory`` without polluting terminal output during ``crystal spec``.
