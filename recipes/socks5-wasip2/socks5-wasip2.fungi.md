---
fungi: service/v1
id: socks5-wasip2

run:
  provider: wasmtime
  source:
    url: https://github.com/enbop/socks5-wasip2/releases/download/v0.1.0/socks5-wasip2.wasm
  args:
    - --listen
    - 127.0.0.1:19080

publish:
  socks5:
    tcp:
      port: 19080
    client:
      kind: socks5
---

# SOCKS5 WASIp2

Runs [socks5-wasip2](https://github.com/enbop/socks5-wasip2) as a
SOCKS5 TCP proxy through Fungi's Wasmtime runtime path.

The proxy supports unauthenticated SOCKS5 `CONNECT` requests with IPv4, IPv6,
and domain-name targets. It does not support `BIND`, `UDP ASSOCIATE`, or
username/password authentication.

## Usage

Configure a SOCKS5 client to use the local endpoint printed by Fungi. Keep DNS
resolution behind the proxy when the client supports it; for example:

```bash
curl --socks5-hostname HOST:PORT https://example.com/
```

## Safety

This service intentionally has no proxy authentication. Use it only through
trusted Fungi device access, and do not expose its listening port directly to
untrusted networks.

Wasmtime receives inherited TCP network and DNS lookup capabilities so the
proxy can connect to requested destinations.

## Source

- Project: <https://github.com/enbop/socks5-wasip2>
- Artifact URL: <https://github.com/enbop/socks5-wasip2/releases/download/v0.1.0/socks5-wasip2.wasm>
