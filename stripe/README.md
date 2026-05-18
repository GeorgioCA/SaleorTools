# Saleor Stripe App

Stripe payment app from the `saleor/apps` monorepo, self-contained with all shared packages.

## Directory Structure

```
stripe/
├── stripe/              # App source code
├── packages/            # Shared monorepo packages
├── Dockerfile
├── docker-compose.yaml
├── pnpm-lock.yaml
├── pnpm-workspace.yaml
└── package.json
```

## Deploy on Coolify

1. In Coolify, add a new resource:
   - **Source**: Git (point to this repo)
   - **Build Pack**: Docker Compose
   - **Base Directory**: `stripe`
   - **Docker Compose file**: `docker-compose.yaml`

3. Set environment variables:
   | Variable | Required | Description |
   |----------|----------|-------------|
   | `STRIPE_SECRET_KEY` | Yes | Encryption key — run `openssl rand -hex 32` |
   | `AWS_ACCESS_KEY_ID` | No | AWS key for DynamoDB persistence |
   | `AWS_SECRET_ACCESS_KEY` | No | AWS secret for DynamoDB persistence |
   | `AWS_REGION` | No | Default: `us-east-1` |
   | `DYNAMODB_MAIN_TABLE_NAME` | No | Default: `stripe-main-table` |

4. Deploy

## Setup DynamoDB (optional)

For production persistence, create the DynamoDB table after first deploy:

```bash
cd stripe
docker compose run --rm stripe pnpm setup-dynamodb
```

## Updating the Stripe App

To update to a newer version:
1. Download the latest `apps-main.zip` from https://github.com/saleor/apps
2. Extract `packages/` and overwrite `stripe/packages/`
3. Copy `pnpm-lock.yaml`, `pnpm-workspace.yaml`, `package.json` from the archive root
4. Extract `apps/stripe/` and overwrite `stripe/stripe/`
5. Update `stripe/pnpm-workspace.yaml` to keep `packages: [stripe, packages/*]`
6. Push and redeploy

## URLs

| Service | URL |
|---------|-----|
| Stripe App | https://stripe.eatforkish.com |
