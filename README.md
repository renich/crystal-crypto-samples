# 🛡️ EVALinux Crypto Suite - Crystal Integration Samples

Welcome to the **EVALinux Crypto Suite**! This repository serves as the central entry point, demonstration ground, and integration sample for the suite of specialized, highly-secure Crystal shards orchestrated by Rénich Bon Ćirić and the Google Antigravity Agent Orchestrator.

If you are looking to build deeply secure, deterministic, and hardware-bound applications in the Crystal programming language, you've found the right ecosystem.

## 🚀 The Crypto Suite Shards

This sample application dynamically links and demonstrates the capabilities of our four foundational shards. We highly encourage you to explore, fork, and utilize these libraries in your own projects!

### 📦 [Crystal CBOR FIDO](https://gitlab.com/renich/crystal-cbor-fido)
A fiercely memory-safe parsing engine for CBOR streams. It utilizes strict boundary limits to prevent buffer overflows and guarantees deterministic byte-array representations to seamlessly comply with FIDO/WebAuthn assertions.

### 🔌 [Crystal DBus Native](https://gitlab.com/renich/crystal-dbus-native)
Native, pure-Crystal DBus integration. It strictly relies on File Descriptor (FD) passing via UNIX sockets, implements SASL ANONYMOUS/EXTERNAL authentication pipelines, and utilizes rigorously typed signature validation to crush malformed packet attacks.

### 🔐 [Crystal ECC Constant](https://gitlab.com/renich/crystal-ecc-constant)
Constant-Time Elliptic Curve Cryptography. Instead of relying on standard GC-managed classes, this shard utilizes isolated `Struct` wrappers natively binding to system `libsodium`. This eradicates Use-After-Free and Double-Free GC vulnerabilities while providing pristine, timing-attack-resistant Ed25519 and X25519 cryptography.

### 🛡️ [Crystal TPM2 TSS](https://gitlab.com/renich/crystal-tpm2-tss)
TPM 2.0 Trusted Software Stack Integration. Unleash your hardware! Features thread-safe session management using M:N Crystal scheduling, FIFO eviction strategies, hardware-bound KDF key derivation, and FIDO2 credential management safely isolated from direct hardware polling loops.

---

## 🛠️ Getting Started

### Official Source
The official, canonical home for this repository is on **GitLab**. To get started, clone the repository directly from the source:

```bash
git clone git@gitlab.com:renich/crystal-crypto-samples.git
cd crystal-crypto-samples
```

*(Note: While a mirror exists on GitHub, GitLab is the primary forge for the EVALinux Crypto Suite).*

### Building the Samples

Ensure you have the required system dependencies (`libsodium-devel` and `tpm2-tss-devel` on Fedora/RHEL, or their `-dev` equivalents on Alpine). 

```bash
# Install the shard dependencies securely from their remote origins
shards install

# Compile and execute the integration samples
crystal run src/crystal_crypto_samples.cr
```

## 📜 Code of Honor
The entire EVALinux Crypto Suite pipeline, architecture, and generated codebase is strictly bound to and respects the [Code of Honor](docs/technical/CODE_OF_HONOR.rst). All contributors and orchestrated agents are expected to read and adhere to it.

## ⚖️ License
This project is proudly published under the **GPLv3** License.

---
*Co-developed-by: Gemini AI <renich+gemini@woralelandia.com>*  
*Signed-off-by: Rénich Bon Ćirić <renich@woralelandia.com>*
