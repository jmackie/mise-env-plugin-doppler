# mise-env-plugin-doppler

Load environment variables from Doppler using `doppler secrets download`.

## Requirements

- `doppler` CLI installed and authenticated

## Usage

Add to your `mise.toml`:

```toml
[env]
_.doppler = { project = "my-app", config = "dev" }
```

### Options

- `project` (required): Doppler project name
- `config` (required): Doppler config name
- `bin` (optional): Path or name of the `doppler` executable (default: `doppler`)
- `cacheable` (optional): Override caching (default: `true`)

### Caching

This plugin returns cacheable results by default. To enable env caching in mise:

```toml
[settings]
env_cache = true
```

## Development

```bash
mise install
mise run lint
```

## Documentation

- [Environment Plugin Development Guide](https://mise.jdx.dev/env-plugin-development.html)
- [mise Documentation](https://mise.jdx.dev)
