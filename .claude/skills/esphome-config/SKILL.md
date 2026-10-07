---
name: esphome-config
description: Add or modify ESPHome device configs in this repo (Sonoff Basic ESP8266 devices and NSPanel). Use when creating a new device YAML, changing GPIO/switch/sensor setup, secrets usage, or validating/compiling/uploading configs.
---

# Configuring ESPHome devices

## Add a Sonoff Basic device

1. Copy `config/kitchen-light.yaml` to `config/<room>-<type>.yaml` (kebab-case, matches device name).
2. Update `esphome.name` (`sonoff-<room>`), `friendly_name`, and entity names (`"<Room> light"`, `"<Room> light button"`).
3. Keep the Sonoff Basic pinout: relay `GPIO12`, button `GPIO0` (pullup, inverted), status LED `GPIO13` (inverted), board `sonoff_basic` under `esp8266:`.
4. Keep `logger`, `api`, `ota` (platform `esphome`), `wifi`, `web_server` (port 80).
5. Credentials always via `!secret` (`wifi_ssid`, `wifi_password`; optional `secure_device_api_key`, `ota_password`, `secure_device_web_username`, `secure_device_web_password`). Never inline or read `secrets.yaml`.
6. Optional hardening blocks are left commented in the templates; uncomment together with the matching secret.

## NSPanel

`config/bathroom-switch.yaml` uses the remote package `edwardtfn/NSPanel-Easy`. Edit only the `substitutions` and the "My customization" area; do not copy package internals. Shared secret `nextion_update_url` is used for TFT upload.

## Validate / build / flash

Dashboard: `docker compose up` → http://localhost:6052 (validate, clean, compile, OTA/serial upload; uses `ESPHOME_DASHBOARD_USE_PING=true` and explicit port mapping because host networking is unavailable on macOS/Windows).

CLI:

```bash
docker compose run --rm -it esphome config <file>.yaml     # validate
docker compose run --rm -it esphome compile <file>.yaml
docker compose run --rm -it esphome upload <file>.yaml
docker compose run --rm -it esphome logs <file>.yaml
```

## Before committing

Run `pre-commit run --all-files`; commit with a Conventional Commit message (see `CLAUDE.md`).
