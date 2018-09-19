# Wiremock Container

Daily builds are run against these images and automatically sent to the DockerHub repository at:

https://hub.docker.com/r/zephinzer/wiremock/


# Usage
To run wiremock:

```
docker run \
		-v "$(pwd)/__files:/app/__files" \
		-v "$(pwd)/mappings:/app/mappings" \
		-p 8080:8080 \
		zephinzer/wiremock:latest
```

> Run `make start` in the `./example` directory

## License
This project is licensed under the [MIT license](./LICENSE)



# Cheers
