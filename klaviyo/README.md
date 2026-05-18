# Saleor Klaviyo App

Klaviyo integration app for sending Saleor events to Klaviyo marketing automation.

## Deploy on Coolify

1. In Coolify:
   - **Source**: Git → this repo
   - **Build Pack**: Docker Compose
   - **Base Directory**: `klaviyo`
   - **Docker Compose file**: `docker-compose.yaml`

3. Set environment variables:
   | Variable | Required | Description |
   |----------|----------|-------------|
   | `SECRET_KEY` | Yes | Encryption key — `openssl rand -hex 32` |

4. Deploy

## URL

| Service | URL |
|---------|-----|
| Klaviyo App | https://klaviyo.example.com |
