# ESPHome

ESPHome configs for Sonoff Basic switches (kitchen, WC). Each device exposes a relay, button, status LED, and a web UI on port 80.

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

Configs live in `config/`. Compose uses host networking on the pinned `ghcr.io/esphome/esphome:2026.7.2` image.

## Usage

```bash
docker compose run --rm -it esphome logs kitchen.yaml
docker compose run --rm -it esphome compile kitchen.yaml
docker compose run --rm -it esphome upload kitchen.yaml
```

Same commands work with `wc.yaml`.

## Pre-commit

Hooks format YAML (`yamlfix`) and enforce [Conventional Commits](https://www.conventionalcommits.org/):

```bash
pre-commit install -t pre-commit -t commit-msg
```
