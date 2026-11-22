FROM docker.io/oven/bun:latest AS builder
WORKDIR /app

ENV NODE_ENV=production

COPY bun.lock package.json .npmrc ./

RUN --mount=type=secret,id=npm_token NODE_AUTH_TOKEN="$(cat /run/secrets/npm_token)" bun install --production --frozen-lockfile --ignore-scripts

COPY src ./src

RUN mkdir -p .fnlb && chown -R 65532:65532 /app

FROM docker.io/oven/bun:distroless
WORKDIR /app

COPY --from=builder --chown=65532:65532 /app /app

USER 65532:65532

CMD ["src/index.js"]
