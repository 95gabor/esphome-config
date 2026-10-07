# ESPHome

ESPHome configs for Sonoff Basic switches (kitchen, WC) and a bathroom switch. Each Sonoff device exposes a relay, button, status LED, and a web UI on port 80.

Docs: [esphome.io](https://esphome.io/)

## Setup

Create `config/secrets.yaml` (gitignored):

```yaml
wifi_ssid: "your-ssid"
wifi_password: "your-password"

# Optional — uncomment matching blocks in the device configs to enable:
# secure_device_api_key: "..."
# ota_password: "..."
# secure_device_web_username: "..."
# secure_device_web_password: "..."
```

Configs live in `config/`. Compose uses the pinned `ghcr.io/esphome/esphome` image (see `docker-compose.yaml`).

## Usage

### Dashboard

```bash
docker compose up
```

Starts the ESPHome dashboard at <http://localhost:6052>. From the dashboard you can edit configs, validate, clean build files, compile, and upload via OTA or serial (the container runs `privileged` for USB access).

#### Networking

Host networking does not work on macOS/Windows (Docker Desktop runs containers in a VM), so Compose uses an explicit port mapping (`6052:6052`) instead. Without host networking the dashboard cannot use mDNS/mTLS-based device discovery and would show devices as offline, so `ESPHOME_DASHBOARD_USE_PING=true` is set. This makes the dashboard determine device status by ping and ignores the failed mTLS.

### CLI

```bash
docker compose run --rm -it esphome logs kitchen-light.yaml
docker compose run --rm -it esphome compile kitchen-light.yaml
docker compose run --rm -it esphome upload kitchen-light.yaml
```

Same commands work with `wc-light.yaml` and `bathroom-switch.yaml`.

## Pre-commit

Hooks format YAML (`yamlfix`) and enforce [Conventional Commits](https://www.conventionalcommits.org/):

```bash
pre-commit install -t pre-commit -t commit-msg
```

The same checks run in CI (`.github/workflows/ci.yaml`) via `pre-commit/action` on every push to `main` and on pull requests targeting `main`.
