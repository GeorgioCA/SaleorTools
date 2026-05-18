# Saleor SMTP App

Email integration app for sending transactional emails via SMTP with MJML/Handlebars templates.

## Deploy on Coolify

1. In Coolify:
   - **Source**: Git → this repo
   - **Build Pack**: Docker Compose
   - **Base Directory**: `smtp`
   - **Docker Compose file**: `docker-compose.yaml`

3. Set environment variables:
   | Variable | Required | Description |
   |----------|----------|-------------|
   | `SECRET_KEY` | Yes | Encryption key — `openssl rand -hex 32` |
   | `SMTP_HOST` | Yes | SMTP server hostname |
   | `SMTP_PORT` | No | Default: `587` |
   | `SMTP_USER` | Yes | SMTP username |
   | `SMTP_PASSWORD` | Yes | SMTP password |
   | `SMTP_SECURE` | No | Default: `false` |
   | `SENDER_ADDRESS` | Yes | Default from address |
   | `SMTP_CONNECTION_URL` | No | Alternative to individual SMTP vars |

4. Deploy

## URL

| Service | URL |
|---------|-----|
| SMTP App | https://smtp.eatforkish.com |
