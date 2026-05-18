FROM node:24-alpine AS base
RUN corepack enable && \
    corepack prepare pnpm@10.28.1 --activate

FROM base AS deps
WORKDIR /app
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json ./
COPY stripe/package.json ./stripe/
COPY packages ./packages
RUN pnpm install --frozen-lockfile --filter saleor-app-payment-stripe...

FROM base AS builder
WORKDIR /app
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json ./
COPY stripe ./stripe
COPY packages ./packages
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/stripe/node_modules ./stripe/node_modules
COPY --from=deps /app/packages ./packages
RUN pnpm --filter saleor-app-payment-stripe build

FROM node:24-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV HOSTNAME=0.0.0.0
ENV PORT=3000

RUN corepack enable && corepack prepare pnpm@10.28.1 --activate

COPY --from=builder /app/pnpm-lock.yaml /app/pnpm-workspace.yaml /app/package.json ./
COPY --from=builder /app/stripe/package.json ./stripe/
COPY --from=builder /app/stripe/next.config.ts ./stripe/
COPY --from=builder /app/stripe/.next ./stripe/.next
COPY --from=builder /app/stripe/node_modules ./stripe/node_modules
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/packages ./packages

EXPOSE 3000
CMD ["pnpm", "--filter", "saleor-app-payment-stripe", "start"]
