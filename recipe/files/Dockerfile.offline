# GENERATED L-009 hermetic build (--network=none, SBOM+SLSA-attestation-producing).
# Pinned bases from BASE_IMAGE_DIGESTS.lock; vendored Go tree + debs from Dockerfile.vendor.
FROM golang:1.27.4-bookworm@sha256:4fa7c968ba93f1635670522dbb01a2c78150443e1385746924566079f36570ea AS build_wireguard-go
WORKDIR /src
COPY vendored/wireguard-src/ .
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOWORK=off GOFLAGS="-mod=vendor -buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1794451831
RUN go build -trimpath -ldflags='' -o /wireguard-go . && /wireguard-go --version > /tmp/wireguard-go.version 2>&1; cat /tmp/wireguard-go.version; grep -qF 'wireguard-go v0.0.20250522' /tmp/wireguard-go.version || { echo 'wireguard-go --version does not report wireguard-go v0.0.20250522'; exit 1; } && \
    { readelf -lW /wireguard-go | sed -n 's/.*Requesting program interpreter: \(.*\)]$/\1/p'; readelf -dW /wireguard-go | sed -n 's/.*Shared library: \[\(.*\)\]$/\1/p'; } > /wireguard-go.needs
# rs-probe: the HEALTHCHECK helper (standard library only, from the kit's rs-probe.go)
FROM golang:1.27.4-bookworm@sha256:4fa7c968ba93f1635670522dbb01a2c78150443e1385746924566079f36570ea AS build_rs_probe
WORKDIR /probe
COPY rs-probe.go main.go
COPY rs-probe.mod go.mod
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOFLAGS="-buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1794451831
RUN go build -trimpath -ldflags='-s -w' -o /rs-probe .
# the chiselled rootfs (vendored/chisel, cut by Dockerfile.vendor), the service user, the binaries
FROM ubuntu:24.04@sha256:2198e4c65076e9cb0b3d695219df667c0e3b0072da64ca3c2648aca17dcecaf5 AS rootfs
ARG SOURCE_DATE_EPOCH=1794451831
ADD vendored/chisel/rootfs.tar /rootfs/
RUN printf 'wireguard:x:999:999::/var/lib/wireguard:/bin/sh\n' >> /rootfs/etc/passwd && printf 'wireguard:x:999:\n' >> /rootfs/etc/group && \
    mkdir -p /rootfs/var/lib/wireguard /rootfs/config /rootfs/run/wireguard && chown -R 999:999 /rootfs/var/lib/wireguard /rootfs/config /rootfs/run/wireguard
COPY --from=build_wireguard-go /wireguard-go /rootfs/usr/local/bin/wireguard-go
COPY --from=build_wireguard-go /wireguard-go.needs /tmp/needs/wireguard-go
COPY --from=build_rs_probe /rs-probe /rootfs/usr/local/bin/rs-probe
COPY wireguard-entrypoint.sh /rootfs/usr/local/bin/wireguard-entrypoint.sh
COPY netadmin /rootfs/usr/local/bin/netadmin
RUN chmod 755 /rootfs/usr/local/bin/wireguard-go /rootfs/usr/local/bin/rs-probe && \
    chown 999:999 /rootfs/usr/local/bin/wireguard-entrypoint.sh && \
    chown 999:999 /rootfs/usr/local/bin/netadmin && \
    chmod 0755 /rootfs/usr/local/bin/wireguard-entrypoint.sh && \
    chmod 0755 /rootfs/usr/local/bin/netadmin
RUN set -eu; ROOT=/rootfs; \
    ln -s mawk "$ROOT/usr/bin/awk"; \
    { mkdir -p "$ROOT/usr/local/libexec/readystack" && cp "$ROOT/usr/bin/setpriv" "$ROOT/usr/local/libexec/readystack/netadmin-setpriv" && chmod 0755 "$ROOT/usr/local/libexec/readystack/netadmin-setpriv" && chroot "$ROOT" /usr/sbin/setcap cap_net_admin=+ep /usr/local/libexec/readystack/netadmin-setpriv && chroot "$ROOT" /usr/sbin/getcap /usr/local/libexec/readystack/netadmin-setpriv | grep -q 'cap_net_admin=ep'; } || { echo 'could not set up the NET_ADMIN launcher' >&2; exit 1; }
RUN --mount=type=bind,source=vendored/chisel,target=/chisel set -eu; \
    for n in /tmp/needs/*; do while read -r lib; do [ -n "$lib" ] || continue; \
      case "$lib" in /*) [ -e "/rootfs$lib" ] ;; *) [ -n "$(find /rootfs/usr/lib /rootfs/usr/lib64 -name "$lib" 2>/dev/null | head -1)" ] ;; esac || \
      { echo "$(basename "$n") needs $lib, which the chiselled rootfs does not have: add its slice to runtime_base.slices" >&2; exit 1; }; \
    done < "$n"; done; rm -rf /tmp/needs; \
    [ -e /rootfs/etc/os-release ] || { echo "no /etc/os-release: base-files_release-info is missing" >&2; exit 1; }; \
    [ "$(grep -c '^Package: ' /rootfs/var/lib/dpkg/status)" = "$(wc -l < /chisel/packages.tsv)" ] || \
      { echo "/var/lib/dpkg/status does not list every package of vendored/chisel/packages.tsv" >&2; exit 1; }; \
    rm -rf /rootfs/var/log/dpkg.log /rootfs/var/log/alternatives.log /rootfs/var/log/apt /rootfs/var/cache/ldconfig/aux-cache /rootfs/var/cache/fontconfig
FROM scratch
ARG SOURCE_DATE_EPOCH=1794451831
COPY --from=rootfs /rootfs/ /
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LABEL org.opencontainers.image.licenses="MIT AND GPL-2.0-only"
LABEL org.opencontainers.image.title="WireGuard"
LABEL org.opencontainers.image.source="https://git.zx2c4.com/wireguard-go"
LABEL org.opencontainers.image.description="WireGuard is the fast, modern, open-source VPN. This image runs a WireGuard interface in userspace (wireguard-go, built from source) with wireguard-tools, as a non-root user that needs only NET_ADMIN and the TUN device: no kernel module, no --privileged."
LABEL org.opencontainers.image.version="0.0.20250522-CE-ubuntu24.04-r5"
LABEL org.opencontainers.image.revision="f333402bd9cbe0f3eeb02507bd14e23d7d639280"
HEALTHCHECK --interval=10s --timeout=60s --start-period=10s \
  CMD wg show interfaces | grep -q . || exit 1
USER wireguard
EXPOSE 51820/udp
ENTRYPOINT ["/usr/local/bin/netadmin", "/usr/local/bin/wireguard-entrypoint.sh"]
