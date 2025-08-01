# AmneziaWG Easy (Fork with amneziawg-go)

> **🚀 Enhanced Fork**: This is a fork of the original [amnezia-wg-easy](https://github.com/spcfox/amnezia-wg-easy) project, upgraded to use the latest [amneziawg-go](https://github.com/amnezia-vpn/amneziawg-go) image for improved performance and security.

## 🔄 Key Changes from Original

| Feature | Original | This Fork |
|---------|----------|-----------|
| **Base Image** | `amneziavpn/amnezia-wg` | `amneziavpn/amneziawg-go` |
| **Node.js** | 18 | 20 (better performance) |
| **Configuration Path** | `/etc/wireguard` | `/etc/amnezia/amneziawg` |
| **Release Version** | 2 | 3 |

## 📋 Requirements

* A host with Docker installed.

## 🏷️ Versions

We provide more then 1 docker image to get, this will help you decide which one is best for you.

| tag | Branch | Example | Description |
| - | - | - | - |
| `latest` | production | `ghcr.io/imbtqd/amnezia-wg-easy:latest` | stable as possible, get bug fixes quickly when needed, deployed against `master`. |
| `3` | production | `ghcr.io/imbtqd/amnezia-wg-easy:3` | same as latest, stick to a version tag. |

---

# AmneziaWG Easy

You have found the easiest way to install & manage AmneziaWG on any Linux host!

<p align="center">
  <img src="./assets/screenshot.png" width="802" />
</p>

## Features

* All-in-one: AmneziaWG + Web UI.
* Easy installation, simple to use.
* List, create, edit, delete, enable & disable clients.
* Download a client's configuration file.
* Statistics for which clients are connected.
* Tx/Rx charts for each connected client.
* Gravatar support.
* Automatic Light / Dark Mode
* Multilanguage Support
* UI_TRAFFIC_STATS (default off)

## Requirements

* A host with Docker installed.

## Versions

We provide more then 1 docker image to get, this will help you decide which one is best for you.

| tag | Branch | Example | Description |
| - | - | - | - |
| `latest` | production | `ghcr.io/wg-easy/wg-easy:latest` or `ghcr.io/wg-easy/wg-easy` | stable as possbile get bug fixes quickly when needed, deployed against `production`. |
| `13` | production | `ghcr.io/wg-easy/wg-easy:13` | same as latest, stick to a version tag. |
| `nightly` | master | `ghcr.io/wg-easy/wg-easy:nightly` | mostly unstable gets frequent package and code updates, deployed against `master`. |
| `development` | pull requests | `ghcr.io/wg-easy/wg-easy:development` | used for development, testing code from PRs before landing into `master`. |

## Installation

### 1. Install Docker

If you haven't installed Docker yet, install it by running:

```bash
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $(whoami)
exit
```

And log in again.

### 2. Run AmneziaWG Easy

```
  docker run -d \
  --name=amnezia-wg-easy \
  -e LANGUAGE=en \
  -e WG_HOST=<🚨YOUR_SERVER_IP> \
  -e PASSWORD=<🚨YOUR_ADMIN_PASSWORD> \
  -e PORT=51821 \
  -e WG_PORT=51820 \
  -e WG_PATH=/etc/amnezia/amneziawg \
  -v ~/.amnezia-wg-easy:/etc/amnezia/amneziawg \
  -p 51820:51820/udp \
  -p 51821:51821/tcp \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  --device=/dev/net/tun:/dev/net/tun \
  --restart unless-stopped \
  ghcr.io/imbtqd/amnezia-wg-easy
```

> 💡 Replace `YOUR_SERVER_IP` with your WAN IP, or a Dynamic DNS hostname.
>
> 💡 Replace `YOUR_ADMIN_PASSWORD` with a password to log in on the Web UI.

The Web UI will now be available on `http://0.0.0.0:51821`.

> 💡 Your configuration files will be saved in `~/.amnezia-wg-easy` and mounted to `/etc/amnezia/amneziawg` inside the container

AmneziaWG Easy can be launched with Docker Compose as well - just download
[`docker-compose.yml`](docker-compose.yml), make necessary adjustments and
execute `docker compose up --detach`.

## Options

These options can be configured by setting environment variables using `-e KEY="VALUE"` in the `docker run` command.

| Env | Default | Example | Description |
| - | - | - | - |
| `LANGUAGE` | `en` | `de` | Web UI language (Supports: en, ru, tr, no, pl, fr, de, ca, es). |
| `CHECK_UPDATE` | `true` | `false` | Check for a new version and display a notification about its availability |
| `PORT` | `51821` | `6789` | TCP port for Web UI. |
| `WEBUI_HOST` | `0.0.0.0` | `localhost` | IP address web UI binds to. |
| `PASSWORD` | - | `foobar123` | When set, requires a password when logging in to the Web UI. |
| `WG_HOST` | - | `vpn.myserver.com` | The public hostname of your VPN server. |
| `WG_DEVICE` | `eth0` | `ens6f0` | Ethernet device the AmneziaWG traffic should be forwarded through. |
| `WG_PORT` | `51820` | `12345` | The public UDP port of your VPN server. AmneziaWG will listen on that (othwise default) inside the Docker container. |
| `WG_MTU` | `null` | `1420` | The MTU the clients will use. Server uses default WG MTU. |
| `WG_PERSISTENT_KEEPALIVE` | `0` | `25` | Value in seconds to keep the "connection" open. If this value is 0, then connections won't be kept alive. |
| `WG_DEFAULT_ADDRESS` | `10.8.0.x` | `10.6.0.x` | Clients IP address range. |
| `WG_DEFAULT_DNS` | `1.1.1.1` | `8.8.8.8, 8.8.4.4` | DNS server clients will use. If set to blank value, clients will not use any DNS. |
| `WG_ALLOWED_IPS` | `0.0.0.0/0, ::/0` | `192.168.15.0/24, 10.0.1.0/24` | Allowed IPs clients will use. |
| `WG_PATH` | `/etc/amnezia/amneziawg` | `/etc/wireguard` | Path where WireGuard configuration files are stored inside the container. |
| `WG_PRE_UP` | `...` | - | See [config.js](/src/config.js#L21) for the default value. |
| `WG_POST_UP` | `...` | `iptables ...` | See [config.js](/src/config.js#L22) for the default value. |
| `WG_PRE_DOWN` | `...` | - | See [config.js](/src/config.js#L29) for the default value. |
| `WG_POST_DOWN` | `...` | `iptables ...` | See [config.js](/src/config.js#L30) for the default value. |
| `UI_TRAFFIC_STATS` | `false` | `true` | Enable detailed RX / TX client stats in Web UI |
| `UI_CHART_TYPE` | `0` | `1` | UI_CHART_TYPE=0 # Charts disabled, UI_CHART_TYPE=1 # Line chart, UI_CHART_TYPE=2 # Area chart, UI_CHART_TYPE=3 # Bar chart |
| `JC` | `random` | `5` | Junk packet count — number of packets with random data that are sent before the start of the session. |
| `JMIN` | `50` | `25` | Junk packet minimum size — minimum packet size for Junk packet. That is, all randomly generated packets will have a size no smaller than Jmin. |
| `JMAX` | `1000` | `250` | Junk packet maximum size — maximum size for Junk packets. |
| `S1` | `random` | `75` | Init packet junk size — the size of random data that will be added to the init packet, the size of which is initially fixed. |
| `S2` | `random` | `75` | Response packet junk size — the size of random data that will be added to the response packet, the size of which is initially fixed. |
| `H1` | `random` | `1234567891` | Init packet magic header — the header of the first byte of the handshake. Must be < uint_max. |
| `H2` | `random` | `1234567892` | Response packet magic header — header of the first byte of the handshake response. Must be < uint_max. |
| `H3` | `random` | `1234567893` | Underload packet magic header — UnderLoad packet header. Must be < uint_max. |
| `H4` | `random` | `1234567894` | Transport packet magic header — header of the packet of the data packet. Must be < uint_max. |

> If you change `WG_PORT`, make sure to also change the exposed port.

## Updating

To update to the latest version, simply run:

```bash
docker stop amnezia-wg-easy
docker rm amnezia-wg-easy
docker pull ghcr.io/imbtqd/amnezia-wg-easy
```

And then run the `docker run -d \ ...` command above again.

With Docker Compose AmneziaWG Easy can be updated with a single command:
`docker compose up --detach --pull always` (if an image tag is specified in the
Compose file and it is not `latest`, make sure that it is changed to the desired
one; by default it is omitted and
[defaults to `latest`](https://docs.docker.com/engine/reference/run/#image-references)). \
The WireGuared Easy container will be automatically recreated if a newer image
was pulled.

## Thanks

Based on [wg-easy](https://github.com/wg-easy/wg-easy) by Emile Nijssen.

This fork is enhanced with the latest [amneziawg-go](https://github.com/amnezia-vpn/amneziawg-go) image for improved performance and security.
