FROM node:24-alpine AS base
RUN corepack enable && \
    corepack prepare pnpm@10.28.1 --activate

FROM base AS deps
WORKDIR /app
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json ./
COPY products-feed/package.json ./products-feed/
COPY packages ./packages
RUN pnpm install --frozen-lockfile --filter saleor-app-products-feed...

FROM base AS builder
WORKDIR /app
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json ./
COPY products-feed ./products-feed
COPY packages ./packages
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/products-feed/node_modules ./products-feed/node_modules
COPY --from=deps /app/packages ./packages
RUN pnpm --filter saleor-app-products-feed build

FROM node:24-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV HOSTNAME=0.0.0.0
ENV PORT=3000

RUN corepack enable && corepack prepare pnpm@10.28.1 --activate

COPY --from=builder /app/pnpm-lock.yaml /app/pnpm-workspace.yaml /app/package.json ./
COPY --from=builder /app/products-feed/package.json ./products-feed/
COPY --from=builder /app/products-feed/next.config.ts ./products-feed/
COPY --from=builder /app/products-feed/.next ./products-feed/.next
COPY --from=builder /app/products-feed/node_modules ./products-feed/node_modules
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/packages ./packages

EXPOSE 3000
CMD ["pnpm", "--filter", "saleor-app-products-feed", "start"]
