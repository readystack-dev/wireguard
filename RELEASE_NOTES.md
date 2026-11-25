# WireGuard 0.0.20250522 — ReadyStack release `0.0.20250522-CE-ubuntu24.04-r5`

Generated 2026-11-12 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/wireguard:0.0.20250522-CE-ubuntu24.04-r5` (linux/amd64). Index digest `sha256:bd92edd6870fd3f2605e152256f8779eb749ee79c3e272fc9999fe725029988c` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:530486d8de2f90ce13092e20179ece5530d40185676e18a21410f66bbc1f20b9` [`TARGET_DIGEST.txt`].
- **Upstream:** WireGuard 0.0.20250522 from https://git.zx2c4.com/wireguard-go [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** none (`FROM scratch`): a chiselled Ubuntu 24.04 runtime, the files Canonical's chisel cut from Ubuntu's own packages (`vendored/chisel/slices.txt`, `vendored/chisel/packages.tsv`); runtime user `wireguard`.
- **Build:** `source-rebuild-go`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `0.0.20250522-CE-ubuntu24.04-r4`.

## What changed in this release

- Upstream version unchanged (0.0.20250522); ReadyStack rebuild.
- Minimum dependency versions ReadyStack enforces on top of upstream (raised only where upstream's own version was lower); shipped versions from the SBOM [`docs/sbom/SBOM.json`]:
  - `golang.org/x/crypto` raised from upstream's `v0.37.0` to at least `v0.57.0` (shipped: `v0.58.0`)
  - `golang.org/x/net` raised from upstream's `v0.39.0` to at least `v0.62.0` (shipped: `v0.62.0`)
  - `golang.org/x/sys` raised from upstream's `v0.32.0` to at least `v0.48.0` (shipped: `v0.49.0`)
- WireGuard 0.0.20250522 is unchanged from the release this supersedes (0.0.20250522-CE-ubuntu24.04-r4); this release rebuilds it. Changes: the image is rebuilt on the current ubuntu:24.04 image (sha256:2198e4c65076…), which its maintainers updated after 0.0.20250522-CE-ubuntu24.04-r4 was built on sha256:fe81560990fa…. Settings, ports and data volumes are those of 0.0.20250522-CE-ubuntu24.04-r4: replace the container with this image on the same volumes.

## Security status at release (measured 2026-11-12)

- **Docker Scout:** 0 fixable critical/high vulnerabilities; runs as `wireguard` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/wireguard:0.0.20250522-CE-ubuntu24.04-r5` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.
- **Before exposing this service:** The container needs --cap-add NET_ADMIN and --device /dev/net/tun (and only these): NET_ADMIN lets the container's processes reconfigure the container's own network namespace, not the host's; it is still a privilege, so grant it to this image only.
- **Before exposing this service:** /config/wg0.conf holds the interface's private key: keep the volume private (the file is written mode 600).

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:530486d8de2f90ce13092e20179ece5530d40185676e18a21410f66bbc1f20b9`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 7 of 7 use cases passed (7 authored) against the running image [`docs/validation/test-results.json`].

## Known issues

- None found (reviewed by held semantic review (Claude) on 2026-11-12).

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/wireguard:0.0.20250522-CE-ubuntu24.04-r5
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

