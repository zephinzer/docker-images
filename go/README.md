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
ARG USER_ID=1000
USER ${USER_ID}
WORKDIR /go/src/app
COPY . /go/src/app
```

Build it with:

```bash
docker build --build-arg USER_ID=$(id -u $(whoami)) -t app .;
```

> In example directory: `make build`

### Initialise Dep

For initialising a dependency management strategy:

```bash
docker run -v "$(pwd):/go/src/app" app dep init;
```

For ensuring all dependencies are installed:

```bash
docker run -v "$(pwd):/go/src/app" app dep ensure;
```

> In example directory: `make init` (does both depending on whether `dep init` fails)

### Developing with live-reload

```bash
docker run -v "$(pwd):/go/src/app" app realize start --run main.go;
```

> In example directory: `make run`

### Compiling

```bash
docker run -v "$(pwd):/go/src/app" app go build -o app
```

> In example directory: `make compile`
