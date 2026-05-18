# SaleorTools

Saleor services and apps deployed on Coolify with a shared Docker network.

## Architecture

Each service runs as a separate Coolify application. Communication between services happens over HTTPS via Coolify's reverse proxy.

```
api.example.com         → Saleor API + PostgreSQL + Valkey + Worker + Jaeger
dashboard.example.com   → Saleor Dashboard
store.example.com       → Saleor Storefront
avatax.example.com      → AvaTax tax calculation app
cms.example.com         → CMS export app (DatoCMS, Contentful, Strapi)
klaviyo.example.com     → Klaviyo marketing automation app
np-atobarai.example.com → NP Atobarai payment app (Japan)
products-feed.example.com → Product feed generator (XML)
search.example.com      → Algolia search integration
segment.example.com     → Twilio Segment analytics app
smtp.example.com        → SMTP email app with MJML templates
stripe.example.com      → Stripe payment app
```

## Core Services

### API (`docker-compose-api.yaml`)

Includes: Saleor API, PostgreSQL, Valkey (Redis), Celery worker, Jaeger tracing.

**Required env files:**
- `common.env` — Common Saleor settings
- `backend.env` — Backend-specific settings

**Deploy:** Point Coolify to `docker-compose-api.yaml`

### Dashboard (`docker-compose-dashboard.yaml`)

**Deploy:** Point Coolify to `docker-compose-dashboard.yaml`

### Storefront (`docker-compose-storefront.yaml`)

**Deploy:** Point Coolify to `docker-compose-storefront.yaml`

## Apps

Each app is in its own directory with a self-contained Docker build (source code + shared packages). No external git clone needed during build.

| Directory | App | URL | Required Env Vars |
|-----------|-----|-----|-------------------|
| `avatax/` | AvaTax | avatax.example.com | `SECRET_KEY`, `AVATAX_ACCOUNT`, `AVATAX_PASSWORD` |
| `cms/` | CMS | cms.example.com | `SECRET_KEY` |
| `klaviyo/` | Klaviyo | klaviyo.example.com | `SECRET_KEY` |
| `np-atobarai/` | NP Atobarai | np-atobarai.example.com | `SECRET_KEY`, `AWS_*` (DynamoDB required) |
| `products-feed/` | Products Feed | products-feed.example.com | `SECRET_KEY` |
| `search/` | Search | search.example.com | `SECRET_KEY`, `ALGOLIA_*` |
| `segment/` | Segment | segment.example.com | `SECRET_KEY`, `SEGMENT_WRITE_KEY` |
| `smtp/` | SMTP | smtp.example.com | `SECRET_KEY`, `SMTP_*`, `SENDER_ADDRESS` |
| `stripe/` | Stripe | stripe.example.com | `SECRET_KEY` |

### Deploying an App on Coolify

For any app (e.g., `stripe`):

1. **Add new resource** in Coolify
2. **Source**: Git → point to this repo
3. **Build Pack**: Docker Compose
4. **Base Directory**: `<app-name>` (e.g., `stripe`)
5. **Docker Compose file**: `docker-compose.yaml`
6. **Set environment variables** (see table above, or check `<app-name>/.env.example`)
7. **Deploy**

Coolify handles all networking automatically — each app gets its own isolated Docker network and communicates with the API over HTTPS.

### Generating SECRET_KEY

Each app needs a `SECRET_KEY` for encryption. Generate one with:

```bash
openssl rand -hex 32
```

### DynamoDB Setup (optional but recommended)

Apps that support DynamoDB for persistent storage:
- `avatax`
- `np-atobarai` (required)
- `segment`
- `stripe`

After first deploy, create the table:

```bash
cd <app-name>
docker compose run --rm <app-name> pnpm setup-dynamodb
```

Without DynamoDB, apps use `FileAPL` which stores credentials on disk — data is lost on container rebuild.

## Updating Apps

### Automated Update

Run the update script to pull the latest code from the `saleor/apps` monorepo:

```bash
pwsh update-apps.ps1
```

This will:
1. Download the latest `saleor/apps` monorepo
2. Update each app's source code and shared packages
3. Preserve local files (`Dockerfile`, `docker-compose.yaml`, `.env.example`, `README.md`, etc.)
4. Clean up temporary files

After updating, commit changes and redeploy in Coolify.

### Manual Update

1. Download latest `apps-main.zip` from https://github.com/saleor/apps
2. Extract and copy the app source to `<app-name>/<app-name>/`
3. Copy `packages/` to `<app-name>/packages/`
4. Copy `pnpm-lock.yaml`, `package.json` to `<app-name>/`
5. Push and redeploy in Coolify

## Directory Structure

```
SaleorTools/
├── docker-compose-api.yaml          # API + DB + cache + worker
├── docker-compose-dashboard.yaml    # Dashboard
├── docker-compose-storefront.yaml   # Storefront
├── avatax/                          # AvaTax app
│   ├── avatax/                      #   App source
│   ├── packages/                    #   Shared packages
│   ├── Dockerfile
│   ├── docker-compose.yaml
│   └── ...
├── cms/                             # CMS app (same structure)
├── klaviyo/                         # Klaviyo app
├── np-atobarai/                     # NP Atobarai app
├── products-feed/                   # Products Feed app
├── search/                          # Search app
├── segment/                         # Segment app
├── smtp/                            # SMTP app
└── stripe/                          # Stripe app
```
