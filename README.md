# Centrifugo

Convenience [Centrifugo](https://centrifugal.dev/) image to run on the dev machine or inside CI.

## Usage

### Docker Compose

```yaml
centrifugo:
  image: ghcr.io/f213/centrifugo-ci
  environment:
    - CENTRIFUGO_SECRET=secret
    - CENTRIFUGO_ADMIN_PASSWORD=password
  ports:
    - 6080:6080
```

### Docker Run

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

## Configuration

- `CENTRIFUGO_SECRET`: Secret key used for JWT, HTTP API and admin secret
- `CENTRIFUGO_ADMIN_PASSWORD`: Admin panel password
- Port `6080`: Main server port
