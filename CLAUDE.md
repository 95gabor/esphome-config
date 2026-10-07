# ESPHome repo

ESPHome device configs run via Docker Compose (`docker-compose.yaml`, dashboard on :6052). See `README.md` for usage.

## Rules

- **Never read, print, or edit `**/secrets.yaml`.** It holds real credentials (gitignored and denied in `.claude/settings.json`). Reference values only via `!secret <key>`; document new keys in the README setup block instead of showing values.
- Configs live in `config/`; build artifacts in `config/.esphome` and `config/configs` are gitignored.
- `.gitignore` is a whitelist (`**` ignored). New tracked files must be explicitly un-ignored there.
- YAML is formatted by `yamlfix` (pre-commit). Run `pre-commit run --all-files` before committing.
- The `docker-compose.yaml` image is pinned by tag and digest; bump both together, preferably with `scripts/update-esphome-image.sh` (multi-arch digest).
- Keep workflow logic in `scripts/` (runnable manually), not in large inline `run:` blocks.

## File naming

- One file per device in `config/`, named after the device in kebab-case: `<room>-<type>.yaml` (e.g. `kitchen-light.yaml`, `wc-light.yaml`, `bathroom-switch.yaml`).
- Filename matches the `esphome.name` / `device_name` where practical (note: Sonoff configs currently use `sonoff-<room>` as `esphome.name`).
- Entity `name:` values are human-readable and include the room (`"Kitchen light"`, `"Kitchen light button"`).

## Git

- Commit messages and PR titles use [Conventional Commits](https://www.conventionalcommits.org/): `type(scope): description`, imperative, lowercase, no trailing period. Enforced locally by the `conventional-pre-commit` hook.
- Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `ci`, `build`, `style`, `test`, `perf`, `revert`.
- Scope is optional, e.g. `config`, `docker`, `ci`, `docs`. Example: `feat(config): add NSPanel configuration`.
- Use `!` or a `BREAKING CHANGE:` footer for breaking changes (e.g. device renames).
- Branch off `main`; PRs target `main` and must pass the pre-commit CI check.

## Skills

- `esphome-config`: how to add or change device configs.
