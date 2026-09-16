# Trivy — Vulnerability Scanner

An open-source vulnerability, misconfiguration, secret, and license scanner by Aqua Security. Deploy the Trivy server on Railway to scan container images from any CI system, Kubernetes cluster, or developer workstation.

# Deploy and Host

Host your own Trivy server on Railway. This template provisions the Trivy API server with automatic vulnerability database updates on startup.

[![Deploy to Railway](https://railway.app/button.svg)](https://railway.com/deploy/trivy)

## Features

- **Vulnerability scanning** — detect CVEs in OS packages, language dependencies (npm, pip, cargo, etc.), and container images
- **Misconfiguration detection** — find insecure settings in Dockerfiles, Kubernetes manifests, Terraform, and more
- **Secret scanning** — catch accidentally committed API keys, tokens, and credentials in source code
- **License scanning** — audit open-source license compliance across dependencies
- **REST API** — integrate with CI/CD pipelines, Kubernetes admission controllers, or developer tooling
- **Auto-updating database** — always scans against the latest vulnerability data on startup
- **Private registry support** — authenticate to Docker Hub, ECR, GCR, ACR, and others via optional env vars

## Quick Start

After deployment, the Trivy server is ready at your Railway public domain:

```bash
# Check server health
curl https://your-domain.railway.app/healthz

# Scan an image for vulnerabilities
curl -X POST https://your-domain.railway.app/trivy/image \
  -H "Content-Type: application/json" \
  -d '{"image": "alpine:3.18"}'
```

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server listen port | `4954` |
| `TRIVY_LISTEN` | Bind address | `0.0.0.0:4954` |
| `TRIVY_CACHE_BACKEND` | Cache storage backend | `fs` |
| `TRIVY_SKIP_DB_UPDATE` | Skip DB updates on startup | `false` |
| `TRIVY_DB_REPOSITORY` | OCI repo for vulnerability DB | `mirror.gcr.io/aquasec/trivy-db:2` |
| `TRIVY_SCANNERS` | Enabled scan types | `vuln,misconfig,secret,license` |

### Private Registry Authentication

To scan images from private registries, set these variables:

| Variable | Description |
|----------|-------------|
| `TRIVY_USERNAME` | Registry username |
| `TRIVY_PASSWORD` | Registry password or token |
| `TRIVY_REGISTRY_TOKEN` | Base64-encoded auth token |

### Redis Cache (Optional)

For a shared cache across multiple replicas, set `TRIVY_CACHE_BACKEND=redis://redis:6379` and add a Redis companion service.

## API Reference

Trivy server exposes the following endpoints:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/healthz` | GET | Health check — returns 200 OK when ready |
| `/trivy/image` | POST | Scan a container image |
| `/trivy/filesystem` | POST | Scan a filesystem/directory |
| `/trivy/repo` | POST | Scan a Git repository |
| `/trivy/sbom` | POST | Generate an SBOM (Software Bill of Materials) |

### Example: Scan an image

```bash
curl -X POST https://your-domain.railway.app/trivy/image \
  -H "Content-Type: application/json" \
  -d '{
    "image": "node:18-alpine",
    "scanners": ["vuln", "secret"]
  }'
```

### Example: Scan a Git repository

```bash
curl -X POST https://your-domain.railway.app/trivy/repo \
  -H "Content-Type: application/json" \
  -d '{
    "repo": "https://github.com/my-org/my-app",
    "scanners": ["vuln", "misconfig", "secret"]
  }'
```

## Dependencies

This template deploys the official `aquasec/trivy` container image from Docker Hub.

## Notes

- The first startup downloads the vulnerability database (~30-50MB). This may take 1-2 minutes.
- Cache stored with `fs` backend is ephemeral — it resets on service restart. Use Redis for persistence.
- Railway provides HTTPS termination automatically. No additional SSL configuration needed.
