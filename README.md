# WireGuard: ReadyStack build kit

The offline build kit for the Docker image `readystack/wireguard:0.0.20250522-CE-ubuntu24.04-r5`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [0.0.20250522-CE-ubuntu24.04-r5](https://github.com/readystack-dev/wireguard/releases/tag/0.0.20250522-CE-ubuntu24.04-r5)
- Image: [`docker.io/readystack/wireguard:0.0.20250522-CE-ubuntu24.04-r5`](https://hub.docker.com/r/readystack/wireguard/tags), manifest digest `sha256:530486d8de2f90ce13092e20179ece5530d40185676e18a21410f66bbc1f20b9`
- Product page: https://readystack.dev/products/wireguard
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=wireguard

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

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/wireguard/recipe. The complete kit is the release download. Each release is a tag here.
