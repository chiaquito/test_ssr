FROM node:20.13-slim AS base

# ビルドステージ
FROM base AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# 実行ステージ
FROM base AS runner
WORKDIR /app
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/.next/standalone ./
# public/配下に画像等を配置する場合はコメントアウトを外す
COPY --from=builder /app/public ./public

ENV HOSTNAME "0.0.0.0"
ENV PORT 3000
EXPOSE 3000

CMD ["node", "server.js"]