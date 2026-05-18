# Saleor AvaTax App

AvaTax integration app for automatic tax calculations.

## Deploy on Coolify

1. In Coolify:
   - **Source**: Git → this repo
   - **Build Pack**: Docker Compose
   - **Base Directory**: `avatax`
   - **Docker Compose file**: `docker-compose.yaml`

3. Set environment variables:
   | Variable | Required | Description |
   |----------|----------|-------------|
   | `SECRET_KEY` | Yes | Encryption key — `openssl rand -hex 32` |
   | `AVATAX_ACCOUNT` | Yes | AvaTax account ID |
   | `AVATAX_PASSWORD` | Yes | AvaTax password |
   | `AVATAX_COMPANY_CODE` | No | Default: `DEFAULT` |
   | `AVATAX_URL` | No | Default: `https://sandbox-rest.avatax.com` |
   | `AWS_*` | No | For DynamoDB persistence |

4. Deploy

## Setup DynamoDB (optional)

```bash
cd avatax
docker compose run --rm avatax pnpm setup-dynamodb
```

## URL

| Service | URL |
|---------|-----|
| AvaTax App | https://avatax.example.com |
