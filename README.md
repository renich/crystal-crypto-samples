# crystal-crypto-samples

[![CI](https://gitlab.com/renich/crystal-crypto-samples/badges/master/pipeline.svg)](https://gitlab.com/renich/crystal-crypto-samples/-/pipelines)
[![License: GPL v3](https://img.shields.io/badge/License-GPL_v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Welcome to the **EVALinux Crypto Suite**! This repository serves as the central demonstration ground, end-to-end integration harness, and usage sample for our suite of specialized, hardware-bound cryptographic Crystal shards.

## The Crypto Suite Shards

This sample application dynamically links and demonstrates the capabilities of our foundational shards:

- **[Crystal CBOR FIDO](https://gitlab.com/renich/crystal-cbor-fido)** (`~> 0.2.0`): Memory-safe Canonical CBOR (RFC 8949 §4.2 / CTAP2 §6) encoder and decoder with canonical float enforcement and trailing-byte rejection.
- **[Crystal DBus Native](https://gitlab.com/renich/crystal-dbus-native)** (`~> 0.2.0`): Native, zero-dependency D-Bus wire protocol with SASL `EXTERNAL` authentication and UNIX domain socket file descriptor passing (`SCM_RIGHTS`).
- **[Crystal ECC Constant](https://gitlab.com/renich/crystal-ecc-constant)** (`~> 0.2.0`): Strictly constant-time Elliptic Curve Cryptography (Ed25519 signatures and X25519 ECDH) backed by libsodium secure memory and `sodium_mprotect_readonly` page protection.
- **[Crystal TPM2 TSS](https://gitlab.com/renich/crystal-tpm2-tss)** (`~> 0.3.0`): Native TPM 2.0 Software Stack featuring hardware NV storage key persistence, KDFa XOR and AES-128-CFB parameter encryption, full FIDO2 credential lifecycle, and $\mathcal{O}(1)$ atomic nonce-reuse detection.

## Getting Started

### Installation & Prerequisites

Ensure host dependencies are installed (`libsodium-devel` and `openssl-devel` on Fedora/RHEL):

```bash
# Clone the repository
git clone git@gitlab.com:renich/crystal-crypto-samples.git
cd crystal-crypto-samples

# Install shard dependencies
shards install
```

### Running the Integration Sample

```bash
make build
./bin/crystal-crypto-samples
```

## Development & Verification

Build targets and test suites are managed via GNU Make:

```bash
make all      # Runs linting (Ameba --all & Flaw), test suite, and builds binary
make check    # Executes crystal spec
make lint     # Executes crystal tool format --check, Ameba --all, and Flaw scanner
make build    # Builds bin/crystal-crypto-samples
make docs     # Generates API documentation into docs/technical/api
```

## Documentation

- **API Documentation**: Generated HTML docs located at [`docs/technical/api/`](docs/technical/api/index.html)
- **Technical Specification**: [`docs/technical/spec.rst`](docs/technical/spec.rst)
- **Project Roadmap**: [`docs/project/roadmap.rst`](docs/project/roadmap.rst)
- **Changelog**: [`CHANGELOG.rst`](CHANGELOG.rst)
- **Code of Honor**: [`docs/technical/CODE_OF_HONOR.rst`](docs/technical/CODE_OF_HONOR.rst)

## License

This project is licensed under the **GNU General Public License v3.0 or later** ([GPL-3.0-or-later](LICENSE)).
