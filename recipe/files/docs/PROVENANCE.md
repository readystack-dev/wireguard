# Provenance — WireGuard (`0.0.20250522-CE-ubuntu24.04-r6`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://git.zx2c4.com/wireguard-go
- Revision built: `0.0.20250522` (commit `f333402bd9cbe0f3eeb02507bd14e23d7d639280`)
- Source tree: `2e29cb47cf21a63d63f493a69e65e0a53adc975d58337280681e571fb728dcd3` over 107 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-go`; base image `scratch + a chiselled Ubuntu 24.04 runtime (vendored/chisel/slices.txt, packages.tsv)`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- SOURCE_DATE_EPOCH: `1795164637` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/wireguard:0.0.20250522-CE-ubuntu24.04-r6` — index digest `sha256:217f6aeeecc92394e4d5212ecf90e18f971777d22d2b48771cf67121893fae2c` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:30ed604f9c8dd949def2a1a506cca1d44ab23575d82365c69a39b0eb1cfdb49e` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/wireguard:0.0.20250522-CE-ubuntu24.04-r6`

## Pinned inputs, and why

- 33 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 3, image digests 2, dependency versions readystack sets 11, pins in the kit's dockerfiles 8, readystack's build engine 5, dependencies upstream chose 2).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-wireguard-0.0.20250522-CE-ubuntu24.04-r6.trail.json`, published beside this archive and signed with the release key (`ReadyStack-wireguard-0.0.20250522-CE-ubuntu24.04-r6.trail.json.sigstore`), and readable at https://readystack.dev/products/wireguard/trail/0.0.20250522-CE-ubuntu24.04-r6.

