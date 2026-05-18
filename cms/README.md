# Saleor CMS App

CMS integration app for exporting products to DatoCMS, Contentful, and Strapi.

## Deploy on Coolify

1. In Coolify:
   - **Source**: Git → this repo
   - **Build Pack**: Docker Compose
   - **Base Directory**: `cms`
   - **Docker Compose file**: `docker-compose.yaml`

3. Set environment variables:
   | Variable | Required | Description |
   |----------|----------|-------------|
   | `SECRET_KEY` | Yes | Encryption key — `openssl rand -hex 32` |

4. Deploy

## URL

| Service | URL |
|---------|-----|
| CMS App | https://cms.example.com |
