# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A thin Docker wrapper around the upstream `centrifugo/centrifugo` image, opinionated for local dev and CI (not production). It bakes in an admin panel, HMAC token auth, and a `personal` + `public` channel namespace layout, then templates a few secrets from env vars at container start. Published to `ghcr.io/f213/centrifugo-ci` as `:latest` and `:<centrifugo-version>` tags.

## Build & run locally

```bash
docker build --build-arg CENTRIFUGO_VERSION=6.3.0 -t centrifugo-ci .
docker run --rm -e CENTRIFUGO_SECRET=secret -e CENTRIFUGO_ADMIN_PASSWORD=password -p 6080:6080 centrifugo-ci
```

There is no test suite, linter, or package manager — `docker build` is the only build step.

## How the image boots (the non-obvious part)

`entrypoint.sh` does two things before starting Centrifugo:

1. Runs `gomplate` over `config-template.json` → `/centrifugo/config.json`, substituting `{{ .Env.X }}` references.
2. **Unsets** `CENTRIFUGO_SECRET`, `CENTRIFUGO_ALLOWED_ORIGIN`, and `CENTRIFUGO_ADMIN_PASSWORD` before `exec centrifugo`. Centrifugo itself treats `CENTRIFUGO_*` env vars as config overrides and would misinterpret or warn about these ad-hoc names.

**Implication:** adding a new templated env var requires *both* a `{{ .Env.X }}` reference in `config-template.json` *and* a matching `unset X` in `entrypoint.sh`.

## Baked-in Centrifugo config

- **Channel namespaces:** `personal` (presence + `allow_user_limited_channels`, used by Centrifugo's auto-subscribe-to-personal-channel feature) and `public`. Client code connecting to this image should use those namespace prefixes.
- **Token auth:** HMAC with `user_id` as the user ID claim.
- **Allowed origins:** hardcoded `http://localhost:3000` plus whatever `CENTRIFUGO_ALLOWED_ORIGIN` resolves to. Supporting more than one extra origin requires editing `config-template.json`.
- **HTTP port:** `6080` (set via `CENTRIFUGO_HTTP_SERVER_PORT` in the Dockerfile).

## Release / versioning

Pushing to `master` triggers `.github/workflows/ci.yml`, which builds a multi-arch (linux/amd64 + linux/arm64) image for every version in the `centrifugo_version` matrix and pushes to GHCR. To support a new upstream Centrifugo release, add the version to that matrix — there are no git tags; image tags come from the matrix values.

## Pinned Alpine packages

`Dockerfile` pins `gomplate==4.2.0-r5` and `dumb-init==1.2.5-r3` via `apk`. Bumping the base `centrifugo/centrifugo` image bumps Alpine, which often invalidates these pins — expect to update them when raising the Centrifugo version.
