# Saleor Search App

Algolia search integration for product search and indexing.

## Deploy on Coolify

1. In Coolify:
   - **Source**: Git → this repo
   - **Build Pack**: Docker Compose
   - **Base Directory**: `search`
   - **Docker Compose file**: `docker-compose.yaml`

3. Set environment variables:
   | Variable | Required | Description |
   |----------|----------|-------------|
   | `SECRET_KEY` | Yes | Encryption key — `openssl rand -hex 32` |
   | `ALGOLIA_APPLICATION_ID` | Yes | Algolia app ID |
   | `ALGOLIA_SEARCH_API_KEY` | Yes | Algolia search-only API key |
   | `ALGOLIA_ADMIN_API_KEY` | Yes | Algolia admin API key |
   | `ALGOLIA_INDEX_PREFIX` | No | Prefix for index names |

4. Deploy

## URL

| Service | URL |
|---------|-----|
| Search App | https://search.eatforkish.com |
