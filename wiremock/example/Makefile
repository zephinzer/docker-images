PATH_FILES=$$(pwd)/__files
PATH_MAPPINGS=$$(pwd)/mappings

# `make start` starts the wiremock server listening on port 8080
#
# PORT : defines the port to be published on the host machine
start:
	-@mkdir -p $(PATH_FILES)
	-@mkdir -p $(PATH_MAPPINGS)
	@if [ -z ${PORT} ]; then \
		$(eval PORT=8080) printf -- "Publishing port ${PORT} on host machine.\n"; \
	fi
	docker run \
		-v "$(PATH_FILES):/app/__files" \
		-v "$(PATH_MAPPINGS):/app/mappings" \
		-p $(PORT):8080 \
		govtechsg/wiremock:latest

# `make debug` opens a shell into the wiremock image
#
# PORT : defines the port to be published on the host machine
debug:
	-@mkdir -p $(PATH_FILES)
	-@mkdir -p $(PATH_MAPPINGS)
	@if [ -z ${PORT} ]; then \
		$(eval PORT=8080) printf -- "Publishing port ${PORT} on host machine.\n"; \
	fi
	docker run \
		-it --entrypoint=/bin/sh \
		-v "$(PATH_FILES):/app/__files" \
		-v "$(PATH_MAPPINGS):/app/mappings" \
		-p $(PORT):8080 \
		govtechsg/wiremock:latest

# `make test` runs tests to make sure that wiremock is working
test:
	-@mkdir -p $(PATH_FILES)
	-@mkdir -p $(PATH_MAPPINGS)
	-@docker stop test_wiremock
	-@docker rm test_wiremock
	@docker run \
		--entrypoint=java \
		-v "$(PATH_FILES):/app/__files" \
		-v "$(PATH_MAPPINGS):/app/mappings" \
		-d \
		-p 8080:8080 \
		--name test_wiremock \
		govtechsg/wiremock:latest \
		-jar wiremock.jar
	@docker exec test_wiremock stat /app/wiremock.jar
	@docker stop test_wiremock
	@docker rm test_wiremock
	-@rm -rf $(PATH_FILES)
	-@rm -rf $(PATH_MAPPINGS)

# `make clean` cleans up all mappings and files for this example
clean:
	-@rm -rf $(PATH_FILES)
	-@rm -rf $(PATH_MAPPINGS)
