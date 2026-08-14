# Agent Architecture & Maintenance Knowledge

This repository was orchestrated by the Google Antigravity Agent Orchestrator to serve as an integration sample for the EVALinux Crypto Suite.

## Project Domain: Crypto Suite Samples
This project demonstrates the simultaneous integration of:
- `crystal-cbor-fido`
- `crystal-dbus-native`
- `crystal-ecc-constant`
- `crystal-tpm2-tss`

## Maintenance Protocols
### 1. Build & Dependencies
- **System Libraries**: Requires `libsodium-devel` and `tpm2-tss-devel` (Fedora) or their `-dev` equivalents on Alpine.
- **Build System**: Uses the standard `GNUmakefile` (`make test`, `make lint`).
### 2. Linting & Formatting
- **No Suppressions**: No `# ameba:disable` or `# flaw:disable`.
- **Line Length**: Max 132 characters.
### 3. Continuous Integration
- Uses GitLab CI with `crystallang/crystal:latest`.
- NO GitHub Actions workflows.

## Code of Honor
The entire codebase respects the [Code of Honor](docs/technical/CODE_OF_HONOR.rst).

## Disclosures
- **Co-developed-by**: Gemini AI <renich+gemini@woralelandia.com>
- **Signed-off-by**: Rénich Bon Ćirić <renich@woralelandia.com>
