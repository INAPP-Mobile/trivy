# Trivy — Vulnerability Scanner

Open-source vulnerability, misconfiguration, secret, and license scanner for container images, filesystems, and Git repositories.

## Deploy and Host

Host your own Trivy server on Railway. This template provisions the Trivy API server with automatic vulnerability database updates on startup.

[![Deploy to Railway](https://railway.app/button.svg)](https://railway.com/deploy/endearing-contentment)

## Why Deploy

Trivy is the open-source scanner used by Aqua Security and adopted across the container ecosystem. Running it on Railway gives you a durable, auto-updating, globally reachable instance with:

- **Always-on scanning** — no local install, accessible from any CI system or developer workstation
- **Auto-updating database** — always scans against the latest vulnerability data on startup
- **gRPC API** — integrate with CI/CD pipelines, Kubernetes admission controllers, or developer tooling
- **Private registry support** — authenticate to Docker Hub, ECR, GCR, ACR, and others via optional env vars
- **Persistent cache** — vulnerability DB cached on a Railway volume for fast restarts

## Common Use Cases

- **CI/CD security scanning** — scan container images in your pipeline before pushing to production
- **Developer workstations** — scan local projects and dependencies for vulnerabilities and secrets
- **Kubernetes admission control** — block vulnerable images from deploying to your cluster
- **Compliance auditing** — audit open-source license compliance across your dependencies
- **Pre-commit hooks** — catch accidentally committed API keys and credentials

### Deployment Dependencies

The deploy form pre-fills all required variables. No additional services needed — Trivy runs as a single container with an optional volume for the vulnerability database cache.

**After the first successful deploy:**

1. Open `https://<your-domain>/healthz` to verify the server is running
2. Use the Trivy client to scan an image: `trivy client --remote https://<your-domain> alpine:3.18`

## About Hosting

Trivy runs as a single container on Railway. The vulnerability database is cached on a Railway volume at `/var/cache/trivy` so restarts are fast. The server listens on port 4954 and exposes a gRPC API for scanning.

## Features

- **Vulnerability scanning** — detect CVEs in OS packages, language dependencies (npm, pip, cargo, etc.), and container images
- **Misconfiguration detection** — find insecure settings in Dockerfiles, Kubernetes manifests, Terraform, and more
- **Secret scanning** — catch accidentally committed API keys, tokens, and credentials in source code
- **License scanning** — audit open-source license compliance across dependencies
- **gRPC API** — integrate with CI/CD pipelines, Kubernetes admission controllers, or developer tooling
- **Auto-updating database** — always scans against the latest vulnerability data on startup
- **Private registry support** — authenticate to Docker Hub, ECR, GCR, ACR, and others via optional env vars

## Dependencies for

- **No external services required** — Trivy runs standalone
- **Optional: Redis companion** — for shared cache across multiple instances (set `TRIVY_CACHE_BACKEND=redis://redis:6379`)

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server listen port. Railway maps this to the public domain. | `4954` |
| `TRIVY_LISTEN` | Bind address for the Trivy server. Must match PORT. | `0.0.0.0:4954` |
| `TRIVY_CACHE_BACKEND` | Cache backend for the vulnerability database. `fs` stores locally. Use `redis://redis:6379` with a Redis companion for shared cache. | `fs` |
| `TRIVY_SKIP_DB_UPDATE` | Skip automatic vulnerability database updates on startup. Not recommended. | `false` |
| `TRIVY_DB_REPOSITORY` | OCI repository to pull the vulnerability database from. | `mirror.gcr.io/aquasec/trivy-db:2` |
| `TRIVY_SCANNERS` | Enabled scanner types. Comma-separated: vuln, misconfig, secret, license. | `vuln,misconfig,secret,license` |

## Quick Start

After deployment, the Trivy server is ready at your Railway public domain:

```bash
# Check server health
curl https://your-domain.up.railway.app/healthz

# Scan an image using Trivy client
trivy client --remote https://your-domain.up.railway.app alpine:3.18

# Scan with specific scanners
trivy client --remote https://your-domain.up.railway.app --scanners vuln,secret nginx:latest

# Scan a filesystem
trivy client --remote https://your-domain.up.railway.app fs /path/to/project
```

## License

Trivy is licensed under the Apache License 2.0. See the [Trivy GitHub repository](https://github.com/aquasecurity/trivy) for details.
