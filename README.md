# Centrifugo

Convenience [Centrifugo](https://centrifugal.dev/) image to run on the dev machine or inside CI.

## Usage

### compose.yml

```yaml
centrifugo:
  image: ghcr.io/f213/centrifugo-ci
  environment:
    - CENTRIFUGO_SECRET=secret
    - CENTRIFUGO_ADMIN_PASSWORD=password
    - CENTRIFUGO_ALLOWED_ORIGINS=http://localhost:3000
  ports:
    - 6080:6080
```

### Docker run

```bash
docker run -d \
  -e CENTRIFUGO_SECRET=secret \
  -e CENTRIFUGO_ADMIN_PASSWORD=password \
  -p 6080:6080 \
  ghcr.io/f213/centrifugo-ci
```

### GitHub Actions

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      centrifugo:
        image: ghcr.io/f213/centrifugo-ci
        env:
          CENTRIFUGO_SECRET: secret
          CENTRIFUGO_ADMIN_PASSWORD: password
        ports:
          - 6080:6080
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: |
          # Your tests here
          # Centrifugo is available at localhost:6080
```

### Custom namespaces

```yaml
centrifugo:
  image: ghcr.io/f213/centrifugo-ci
  environment:
    - CENTRIFUGO_SECRET=secret
    - CENTRIFUGO_ADMIN_PASSWORD=password
    - CENTRIFUGO_PERSONAL_NAMESPACE=user
    - CENTRIFUGO_ADDITIONAL_PERSONAL_NAMESPACES=notifications,dm
  ports:
    - 6080:6080
```

The example above produces four channel namespaces: `user`, `notifications`, `dm`, `public`. Clients are auto-subscribed to `user#<user_id>`; `notifications` and `dm` behave the same way (presence + user-limited channels) but must be subscribed to explicitly.

### Multiple origins

```yaml
centrifugo:
  image: ghcr.io/f213/centrifugo-ci
  environment:
    - CENTRIFUGO_SECRET=secret
    - CENTRIFUGO_ADMIN_PASSWORD=password
    - CENTRIFUGO_ALLOWED_ORIGINS=http://localhost:3000,https://app.example.com
  ports:
    - 6080:6080
```

Setting `CENTRIFUGO_ALLOWED_ORIGINS` replaces the default (`http://localhost:3000`), so include it explicitly if you still want local dev to work.

## Configuration

- `CENTRIFUGO_SECRET`: Secret key used for JWT, HTTP API and admin secret
- `CENTRIFUGO_ADMIN_PASSWORD`: Admin panel password
- `CENTRIFUGO_ALLOWED_ORIGINS`: Comma-separated list of allowed origins. Default: `http://localhost:3000`
- `CENTRIFUGO_PERSONAL_NAMESPACE`: Name of the built-in personal channel namespace (also the auto-subscribe target). Default: `personal`
- `CENTRIFUGO_ADDITIONAL_PERSONAL_NAMESPACES`: Comma-separated list of extra personal-style namespaces (each gets `presence` and `allow_user_limited_channels`). Default: empty
- Port `6080`: Main server port
