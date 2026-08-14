# crystal-crypto-samples

[![CI](https://gitlab.com/renich/crystal-crypto-samples/badges/master/pipeline.svg)](https://gitlab.com/renich/crystal-crypto-samples/-/pipelines)
[![License: GPL v3](https://img.shields.io/badge/License-GPL_v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Welcome to the **EVALinux Crypto Suite**! This repository serves as the central demonstration ground, end-to-end integration harness, and usage sample for the suite of specialized, hardware-bound cryptographic Crystal shards.

## The Crypto Suite Shards

This sample application dynamically links and demonstrates the capabilities of our foundational shards:

- **[Crystal CBOR FIDO](https://gitlab.com/renich/crystal-cbor-fido)**: Memory-safe Canonical CBOR parser and encoder compliant with FIDO2/WebAuthn assertions.
- **[Crystal DBus Native](https://gitlab.com/renich/crystal-dbus-native)**: Native, zero-dependency D-Bus wire protocol with SASL authentication and UNIX domain socket file descriptor passing (`SCM_RIGHTS`).
- **[Crystal ECC Constant](https://gitlab.com/renich/crystal-ecc-constant)**: Strictly constant-time Elliptic Curve Cryptography (Ed25519 signatures and X25519 ECDH) backed by libsodium.
- **[Crystal TPM2 TSS](https://gitlab.com/renich/crystal-tpm2-tss)**: TPM 2.0 Software Stack featuring hardware NV storage key persistence, session-based parameter encryption, and $\mathcal{O}(1)$ nonce-reuse detection.

## Getting Started

### Installation & Prerequisites

Ensure host dependencies are installed (`libsodium-devel` and `tpm2-tss-devel` on Fedora/RHEL):

```bash
# Clone the repository
git clone git@gitlab.com:renich/crystal-crypto-samples.git
cd crystal-crypto-samples

# Install shard dependencies
shards install
```

### Running the Integration Sample

```bash
crystal run src/crystal_crypto_samples.cr
```

## Development & Verification

Build targets and test suites are managed via GNU Make:

```bash
make all      # Runs linting (Ameba & Flaw) and test suite
make test     # Executes crystal spec
make lint     # Executes Ameba static analysis and Flaw scanner
make docs     # Generates API documentation into docs/technical/api
```

## Documentation

- **API Documentation**: Generated HTML docs located at [`docs/technical/api/`](docs/technical/api/index.html).
- **Technical Specification**: [`docs/technical/spec.rst`](docs/technical/spec.rst)
- **Project Roadmap**: [`docs/project/roadmap.rst`](docs/project/roadmap.rst)
- **Changelog**: [`CHANGELOG.rst`](CHANGELOG.rst)
- **Code of Honor**: [`docs/technical/CODE_OF_HONOR.rst`](docs/technical/CODE_OF_HONOR.rst)

## License

This project is licensed under the **GNU General Public License v3.0 or later** ([GPL-3.0-or-later](LICENSE)).
