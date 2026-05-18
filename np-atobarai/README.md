# Saleor NP Atobarai App

NP Atobarai (Japanese: NP 後払い) payment integration app.

## Deploy on Coolify

1. In Coolify:
   - **Source**: Git → this repo
   - **Build Pack**: Docker Compose
   - **Base Directory**: `np-atobarai`
   - **Docker Compose file**: `docker-compose.yaml`

3. Set environment variables:
   | Variable | Required | Description |
   |----------|----------|-------------|
   | `SECRET_KEY` | Yes | Encryption key — `openssl rand -hex 32` |
   | `AWS_ACCESS_KEY_ID` | Yes | Required for DynamoDB |
   | `AWS_SECRET_ACCESS_KEY` | Yes | Required for DynamoDB |
   | `AWS_REGION` | No | Default: `us-east-1` |
   | `DYNAMODB_MAIN_TABLE_NAME` | No | Default: `np-atobarai-main-table` |

4. Deploy

## Setup DynamoDB

```bash
cd np-atobarai
docker compose run --rm np-atobarai pnpm setup-dynamodb
```

## URL

| Service | URL |
|---------|-----|
| NP Atobarai App | https://np-atobarai.eatforkish.com |
