[![ReadyStack](https://readystack.dev/logo.svg)](https://readystack.dev)

**Stable, Open-source Releases, Automated** · [readystack.dev](https://readystack.dev)

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-readystack%2Fwireguard-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/readystack/wireguard) [![Docker pulls](https://img.shields.io/docker/pulls/readystack/wireguard)](https://hub.docker.com/r/readystack/wireguard) [![Grade at release](https://img.shields.io/badge/grade%20at%20release-A%20%2894%25%29-2ea44f)](https://readystack.dev/products/wireguard) [![Signed: cosign](https://img.shields.io/badge/signed-cosign-2ea44f)](https://readystack.dev/keys/cosign.pub) ![SBOM: SPDX](https://img.shields.io/badge/SBOM-SPDX-2ea44f) ![Provenance: SLSA v1](https://img.shields.io/badge/provenance-SLSA%20v1-2ea44f) ![Offline rebuild: verified](https://img.shields.io/badge/offline%20rebuild-verified-2ea44f)

# WireGuard: ReadyStack build kit

The offline build kit for the Docker image `readystack/wireguard:0.0.20250522-CE-ubuntu24.04-r5`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [0.0.20250522-CE-ubuntu24.04-r5](https://github.com/readystack-dev/wireguard/releases/tag/0.0.20250522-CE-ubuntu24.04-r5)
- Image: [`docker.io/readystack/wireguard:0.0.20250522-CE-ubuntu24.04-r5`](https://hub.docker.com/r/readystack/wireguard/tags), manifest digest `sha256:530486d8de2f90ce13092e20179ece5530d40185676e18a21410f66bbc1f20b9`
- Product page: https://readystack.dev/products/wireguard
- Source and build recipe: https://readystack.dev/products/wireguard/recipe
- Build trail: https://readystack.dev/products/wireguard/trail/0.0.20250522-CE-ubuntu24.04-r5
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=wireguard

## The image

A single container running wireguard-go for one interface (wg0 by default) as the non-root user wireguard, configured from /config/wg0.conf (the wg-quick file format: [Interface] and [Peer] sections). WireGuard listens on udp 51820. It needs two privileges, both declared: --cap-add NET_ADMIN (to create and configure the network interface) and --device /dev/net/tun (the TUN device the userspace interface runs on). No kernel module and no --privileged. Peers reach networks behind this container only if you also route or NAT them on the host; inside the container it routes each peer's AllowedIPs through wg0.

## Who uses WireGuard and why

Network administrators and individuals who need a simple, secure VPN between servers, sites or devices.

WireGuard is a simple, modern VPN that uses current cryptography. Peers authenticate each other by exchanging public keys, much like SSH keys, and the tunnel can roam between IP addresses.

A typical use: A small company needs staff laptops to reach servers on its office network. A WireGuard endpoint at the office holds each laptop's public key and allowed addresses; each laptop connects with a short configuration file, and the tunnel keeps working as the laptop moves between networks.

From the upstream project's own description: https://www.wireguard.com/, https://git.zx2c4.com/wireguard-go/about/.

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-12 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 37 packages with copyleft licences (GPL, LGPL, MPL), all of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component).
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`wireguard`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-12; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/wireguard.

WireGuard is distributed under its upstream licence (MIT AND GPL-2.0-only); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [0.0.20250522-CE-ubuntu24.04-r5 release](https://github.com/readystack-dev/wireguard/releases/tag/0.0.20250522-CE-ubuntu24.04-r5): `ReadyStack-wireguard-0.0.20250522-CE-ubuntu24.04-r5.tar.gz` (444.6 MB), SHA-256 `66c80533739bf6f57bbd2ff8f0c8a433f527ed85960924988ba48593db39418b`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-wireguard-0.0.20250522-CE-ubuntu24.04-r5.rebuild.json.sigstore ReadyStack-wireguard-0.0.20250522-CE-ubuntu24.04-r5.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-wireguard-0.0.20250522-CE-ubuntu24.04-r5.tar.gz
cd 0.0.20250522-CE-ubuntu24.04-r5
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-wireguard-0.0.20250522-CE-ubuntu24.04-r5.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/wireguard/recipe. The complete kit is the release download. Each release is a tag here. How to report a vulnerability: [SECURITY.md](SECURITY.md).

## About ReadyStack

**Stable, Open-source Releases, Automated.** ReadyStack releases popular open-source apps every week with every available critical and high security fix applied, plus full documentation, reference data, tests and a build recipe that recreates each release bit-for-bit. Each release is rebuilt from its pinned inputs with the network off, checked against its published digest, signed, and scanned and graded again every day. The images and build kits are free, and ReadyStack is soon to be a nonprofit.

[readystack.dev](https://readystack.dev) · [All products](https://readystack.dev/products.html) · [Build kits on GitHub](https://github.com/readystack-dev) · [Defect log](https://readystack.dev/defects.html) · contact@readystack.dev

— ReadyStack · https://readystack.dev
