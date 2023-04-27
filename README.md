# peaceful-ares-webapp

Web application for _Project Peaceful Ares_ -- a tool for fitness tracking.

Built with 💖 using SvelteKit.

## Requirements

Below is the list of requirements needed to run and develop the project.

- [Docker](https://docs.docker.com/get-docker/)
- [Node](https://nodejs.org/en/download) _v16.14 or higher_
- [Pnpm](https://pnpm.io/installation)

## Development

After cloning the project make a copy of [.env.example](./.env.example) called
`.env`, then run

```bash
docker compose up --no-deps --build
```

to build the [Dockerfile](./Dockerfile) and start a development container.

## Configuration

For project configuration, change environment variables in `.env`.

Refer to the table below for an overview of the configuration options.

| environment variable | explanation                                     | default value |
| -------------------- | ----------------------------------------------- | ------------- |
| VITE_PORT            | Port that the the SvelteKit webapp will run on. | 3000          |
