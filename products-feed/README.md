# Saleor Products Feed App

Generates product feed XML for Google Shopping, price comparison sites, etc.

## Deploy on Coolify

1. In Coolify:
   - **Source**: Git → this repo
   - **Build Pack**: Docker Compose
   - **Base Directory**: `products-feed`
   - **Docker Compose file**: `docker-compose.yaml`

3. Set environment variables:
   | Variable | Required | Description |
   |----------|----------|-------------|
   | `SECRET_KEY` | Yes | Encryption key — `openssl rand -hex 32` |
   | `AWS_*` / `S3_*` | No | For S3 feed file uploads |

4. Deploy

## URL

| Service | URL |
|---------|-----|
| Products Feed App | https://products-feed.example.com |
