FROM node:16-bullseye-slim AS base
LABEL maintainer="bram_lo@outlook.com"
ARG VITE_PORT=3000
ENV VITE_PORT=${VITE_PORT}
EXPOSE $VITE_PORT
RUN npm install -g pnpm@8.3.1
RUN mkdir /app && chown -R node:node /app
WORKDIR /app
USER node
COPY --chown=node:node .npmrc package.json pnpm-lock.yaml ./
RUN pnpm install

FROM base AS development
ENV NODE_ENV=development
ENV PATH=/app/node_modules/.bin:$PATH
RUN pnpm install --only=development
CMD ["pnpm", "dev", "--", "--host", "0.0.0.0"]

FROM base AS vitest_tests
COPY . ./
RUN pnpm lint \
    && npx vitest --run

FROM mcr.microsoft.com/playwright:v1.28.1-focal AS playwright_tests
RUN npm install -g pnpm@8.3.1
WORKDIR /app
COPY --chown=node:node .npmrc package.json pnpm-lock.yaml ./
RUN pnpm install
COPY . ./
RUN pnpm test

FROM base AS build
COPY --chown=node:node . ./
RUN pnpm build

FROM node:16-bullseye-slim AS production
ENV NODE_ENV=production

# Use tini for better kernel signal handling.
# This way tini is run with PID 1 and our main.js gets a different PID.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    tini \
    && rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/tini /usr/local/bin/tini
RUN mkdir /app && chown -R node:node /app
WORKDIR /app
USER node
COPY --chown=node:node --from=build /app/node_modules ./node_modules
COPY --chown=node:node --from=build /app/build ./build
COPY --chown=node:node --from=build /app/package.json ./

# set entrypoint to always run commands with tini
ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["node", "build"]
