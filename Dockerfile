FROM docker.io/oven/bun:latest@sha256:3aa040e5445efa09d75bb428a64ba50db13e2b3ac9b6b0c7f145615f62b2ee18 AS builder
WORKDIR /app

ENV NODE_ENV=production

COPY bun.lock package.json ./

RUN bun install --production --frozen-lockfile --ignore-scripts

COPY src ./src

RUN mkdir -p .fnlb && chown -R 65532:65532 /app

FROM docker.io/oven/bun:distroless@sha256:3a210956422ad81cf7532e1fc1f2eb9275d6ef4c2337a9d25d530f798e80726a
WORKDIR /app

COPY --from=builder --chown=65532:65532 /app /app

USER 65532:65532

CMD ["src/index.js"]
