FROM node:16-bullseye-slim as base
LABEL maintainer="bram_lo@outlook.com"
ARG VITE_PORT=3000
ENV VITE_PORT=${VITE_PORT}
EXPOSE $VITE_PORT
RUN mkdir /app && chown -R node:node /app
WORKDIR /app
USER node
COPY --chown=node:node package*.json ./
RUN npm ci && npm cache clean --force

FROM base as development
ENV NODE_ENV=development
ENV PATH=/app/node_modules/.bin:$PATH
RUN npm install --only=development
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

FROM base as vitest_tests
COPY . ./
RUN npm run lint \
    && npx vitest --run

FROM mcr.microsoft.com/playwright:v1.32.0-focal as playwright_tests
WORKDIR /app
COPY package*.json ./
RUN npm ci && npm cache clean --force
COPY . ./
RUN npm run test

FROM base as build
COPY --chown=node:node . ./
RUN npm run build

FROM node:16-bullseye-slim as production
ENV NODE_ENV=production

# Use tini for better kernel signal handling.
# This way tini is run with PID 1 and our main.js gets a different PID.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    tini \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --chown=node:node --from=build /app/node_modules ./node_modules
COPY --chown=node:node --from=build /app/build ./build
COPY --chown=node:node --from=build /app/package.json ./

# set entrypoint to always run commands with tini
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "build"]
