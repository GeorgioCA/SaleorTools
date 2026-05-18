# Saleor Segment App

Twilio Segment integration for sending Saleor events to analytics platforms.

## Deploy on Coolify

1. In Coolify:
   - **Source**: Git → this repo
   - **Build Pack**: Docker Compose
   - **Base Directory**: `segment`
   - **Docker Compose file**: `docker-compose.yaml`

3. Set environment variables:
   | Variable | Required | Description |
   |----------|----------|-------------|
   | `SECRET_KEY` | Yes | Encryption key — `openssl rand -hex 32` |
   | `SEGMENT_WRITE_KEY` | Yes | Segment write key |
   | `AWS_*` | No | For DynamoDB persistence |

4. Deploy

## Setup DynamoDB (optional)

```bash
cd segment
docker compose run --rm segment pnpm setup-dynamodb
```

## URL

| Service | URL |
|---------|-----|
| Segment App | https://segment.example.com |
