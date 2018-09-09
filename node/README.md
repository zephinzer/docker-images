# Node Image
This is a development and production image for Node

## Additional Tooling
- [Nodemon for live-reloading](https://github.com/remy/nodemon)

## Additional Tooling in Development
- Bash for ease of debugging
- Curl for sending HTTP messages
- Git for pulling and pushing repositories

## Example Usage
The following example is also available in [the example directory](./example).

### Dockerfile
```dockerfile
FROM zephinzer/node:8.11.4-alpine-dev
ARG USER_ID=1000
USER ${USER_ID}
WORKDIR /app
COPY ./package.json /app/package.json
RUN npm install
COPY . /app
ENTRYPOINT [ "nodemon", "src/main.js" ]
```

Then build it with:

```bash
docker build --build-arg USER_ID=$(id -u $(whoami)) -t app .
```

> In example directory: `make build`

### Install dependencies

```bash
docker run -v "$(pwd)/src:/app/src" --entrypoint=npm app install;
```

> In example directory: `make init`

### Developing with live-reload

```bash
docker run -v "$(pwd)/src:/app/src" app nodemon src/main.js;
```

> In example directory: `make run`

