============
Contributing
============

First off, thank you for considering contributing to the EVALinux Crypto Suite! It is people like you that make open-source software secure and robust.

Code of Honor
=============

This project strictly adheres to the `Code of Honor <CODE_OF_HONOR.rst>`__. By participating, you are expected to uphold this code.

Development Guidelines
======================

#. **Test-Driven Development**: All new features or bug fixes must be accompanied by relevant specifications in ``spec/``.
#. **Coverage**: The test suite must maintain strict ``> 80%`` coverage.
#. **Linting**: We enforce a strict 120-character line limit. Run ``make lint`` and ``make doc-check`` prior to committing. Absolutely no linter suppressions such as ``# ameba:disable`` or ``# flaw:disable`` are allowed.
#. **Build System**: All tasks for testing, linting, and building documentation must utilize the existing ``GNUmakefile``.

Pull Request Process
====================

#. Create a descriptive branch from ``master``.
#. Ensure your changes compile and pass ``make all`` and ``make doc-check`` against the Alpine CI container specifications.
#. Update ``CHANGELOG.rst`` following the ``Keep a Changelog 1.1.0`` guidelines.
#. Add your ``Signed-off-by`` trailer to your commits.
