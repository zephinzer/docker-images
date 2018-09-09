# Go Image
This is a image with Go installed.

## Additional Tooling
- [Realize for live-reloads](https://github.com/oxequa/realize)
- [Dep for dependency management](https://github.com/golang/dep)

## Example Usage
The following example is also available in [the example directory](./example).

### Example Dockerfile
```dockerfile
FROM zephinzer/go:1.11
ARG PROJECT_NAME=app
WORKDIR /go/src/${PROJECT_NAME}
COPY . /go/src/${PROJECT_NAME}
```

Build it with:

```bash
docker build --build-arg PROJECT_NAME=${PROJECT_NAME} -t app .
```

> In example directory: `make build`

### Initialise Dep

For initialising a dependency management strategy:

```bash
docker run -v "$(pwd):/go/src/${PROJECT_NAME}" app dep init
```

For ensuring all dependencies are installed:

```bash
docker run -v "$(pwd):/go/src/${PROJECT_NAME}" app dep ensure
```

> In example directory: `make init` (does both depending on whether `dep init` fails)

### Developing with live-reload

```bash
docker run -v "$(pwd):/go/src/${PROJECT_NAME}" app realize start --run main.go
```

> In example directory: `make run`

### Compiling

```bash
docker run -v "$(pwd):/go/src/${PROJECT_NAME}" app go build -o app
```

> In example directory: `make compile`
