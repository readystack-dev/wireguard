#!/bin/sh
# ReadyStack WireGuard entrypoint: brings up one WireGuard interface in userspace (wireguard-go) as the non-root user
# wireguard, from a wg-quick style file /config/<interface>.conf (WG_INTERFACE, default wg0). It needs exactly
# `--cap-add NET_ADMIN` (wireguard-go and ip carry cap_net_admin as file capabilities, effective only when the
# container is granted it) and `--device /dev/net/tun` (the TUN device wireguard-go creates the interface on).
#
# On the first start, when the file does not exist, it writes one with a new private key, Address WG_ADDRESS
# (default 10.13.13.1/24) and ListenPort WG_LISTEN_PORT (default 51820), and prints the public key; add [Peer]
# sections and restart. The [Interface] keys only wg-quick knows are applied here: Address (the interface's
# addresses) and MTU; every peer's AllowedIPs gets a route through the interface, except 0.0.0.0/0 and ::/0
# (a full tunnel needs wg-quick's policy routing, which this image does not do). DNS, Table, SaveConfig and the
# Pre/PostUp/Down hooks are not supported and stop the start with a message. Everything else goes to `wg setconf`.
set -eu
IFACE="${WG_INTERFACE:-wg0}"
CONF="/config/${IFACE}.conf"
RUN="/var/run/wireguard"
case "$IFACE" in *[!A-Za-z0-9_=+.-]*|"") echo "readystack: WG_INTERFACE must be an interface name" >&2; exit 1 ;; esac
if [ ! -f "$CONF" ]; then
  KEY="$(wg genkey)"
  ( umask 077
    printf '[Interface]\nAddress = %s\nListenPort = %s\nPrivateKey = %s\n' \
      "${WG_ADDRESS:-10.13.13.1/24}" "${WG_LISTEN_PORT:-51820}" "$KEY" > "$CONF" )
  echo "readystack: wrote $CONF; this interface's public key is $(printf '%s' "$KEY" | wg pubkey)" >&2
  echo "readystack: add a [Peer] section per peer (PublicKey, AllowedIPs, Endpoint) and restart the container" >&2
fi
STRIPPED="$(mktemp)"; chmod 600 "$STRIPPED"
# Split the file: wg-quick-only [Interface] keys to shell variables, the rest to the file `wg setconf` reads.
eval "$(awk -v out="$STRIPPED" '
  function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
  /^[ \t]*\[/ { sect = tolower(trim($0)); print $0 > out; next }
  /^[ \t]*(#|$)/ { next }
  {
    k = $0; sub(/=.*/, "", k); k = tolower(trim(k)); v = $0; sub(/^[^=]*=/, "", v); v = trim(v)
    if (sect == "[interface]" && k == "address") { gsub(/,/, " ", v); gsub(/[^0-9A-Fa-f:.\/ ]/, "", v); addr = addr " " v; next }
    if (sect == "[interface]" && k == "mtu") { gsub(/[^0-9]/, "", v); mtu = v; next }
    if (sect == "[interface]" && (k == "dns" || k == "table" || k == "saveconfig" || k ~ /^(pre|post)(up|down)$/)) { bad = bad " " k; next }
    print $0 > out
  }
  END { printf "ADDRS=\x27%s\x27\nMTU=\x27%s\x27\nUNSUPPORTED=\x27%s\x27\n", addr, mtu, bad }
' "$CONF")"
if [ -n "$UNSUPPORTED" ]; then
  echo "readystack: $CONF uses wg-quick keys this image does not apply:$UNSUPPORTED (remove them)" >&2; exit 1
fi
# a restarted container keeps the previous run's socket: remove it so the wait below sees the new one
rm -f "$RUN/$IFACE.sock"
[ -c /dev/net/tun ] || { echo "readystack: /dev/net/tun is missing: start the container with --device /dev/net/tun" >&2; exit 1; }
wireguard-go -f "$IFACE" &
WGPID=$!
trap 'kill -TERM "$WGPID" 2>/dev/null' TERM INT
i=0; until [ -S "$RUN/$IFACE.sock" ]; do
  i=$((i + 1)); kill -0 "$WGPID" 2>/dev/null || { wait "$WGPID" || true; echo "readystack: wireguard-go exited (it needs --cap-add NET_ADMIN and --device /dev/net/tun)" >&2; exit 1; }
  [ "$i" -lt 100 ] || { echo "readystack: wireguard-go did not open $RUN/$IFACE.sock" >&2; exit 1; }
  sleep 0.1
done
wg setconf "$IFACE" "$STRIPPED"; rm -f "$STRIPPED"
for a in $ADDRS; do ip address add "$a" dev "$IFACE"; done
[ -z "$MTU" ] || ip link set mtu "$MTU" dev "$IFACE"
ip link set up dev "$IFACE"
for cidr in $(wg show "$IFACE" allowed-ips | cut -f2- | tr ' \t' '\n\n' | sort -u); do
  case "$cidr" in
    "(none)"|"") ;;
    0.0.0.0/0|::/0) echo "readystack: no route for $cidr: a full tunnel needs policy routing this image does not do" >&2 ;;
    *) ip route replace "$cidr" dev "$IFACE" ;;
  esac
done
echo "readystack: $IFACE is up ($(wg show "$IFACE" listen-port | sed 's/^/listening on udp /'))" >&2
wait "$WGPID"
