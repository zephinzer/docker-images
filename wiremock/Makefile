# make a copy of `./sample.properties` file  as `./Makefile.properties`
include ../Makefile.properties

# general paths so we don't need to keep retyping
DOCKERREPO=$(DOCKERUSER)/wiremock
TAGS_LIST_PATH=./.make.build.tags
BUILD_ARTIFACTS_PATH=./.make.build.artifacts

# run all possible builds
build:
	-@rm -rf $(TAGS_LIST_PATH)
	$(MAKE) build.wiremock

# publish everything
publish: build
	-@touch $(TAGS_LIST_PATH)
	@cat ./$(TAGS_LIST_PATH) | xargs -P 10 -I@ $(MAKE) TAG="@" publish.dockerhub
	-@rm -rf $(TAGS_LIST_PATH)

# build driver for wiremock - call this to initialise pre-requisites for build.wiremock.docker and run the build
build.wiremock:
	-@mkdir $(BUILD_ARTIFACTS_PATH)
	$(MAKE) get.wiremock.version
	@printf -- "\n\033[32m\033[1mINFO: Wiremock at version $$(cat $(BUILD_ARTIFACTS_PATH)/version.wiremock) was found from Wiremock's GitHub page.\033[0m\n\n";
	$(MAKE) get.alpine.version.docker
	@printf -- "\n\033[32m\033[1mINFO: Alpine at version $$(cat $(BUILD_ARTIFACTS_PATH)/version.alpine.docker) was found on DockerHub.\033[0m\n\n";
	$(MAKE) build.wiremock.docker

# publishes this image with additional tagging to dockerhub
publish.dockerhub:
	$(eval ALPINE_VERSION=$(shell cat $(BUILD_ARTIFACTS_PATH)/version.alpine.docker))
	@printf -- "\n\033[32m\033[1mINFO: Alpine is at version $(ALPINE_VERSION).\033[0m\n\n"
	$(MAKE) log.info MSG="Pushing detailed tag..."
	docker tag ${TAG} ${TAG}-alpine${ALPINE_VERSION}
	docker push ${TAG}-alpine${ALPINE_VERSION}
	$(MAKE) log.info MSG="Pushing canonical tag..."
	docker tag ${TAG} $(DOCKERREGISTRY)/${TAG}
	docker push $(DOCKERREGISTRY)/${TAG}
	$(MAKE) log.info MSG="Pushing latest tag..."
	docker tag ${TAG} $(DOCKERREGISTRY)/$(DOCKERREPO):latest
	docker push $(DOCKERREGISTRY)/$(DOCKERREPO):latest

# builds the actual wiremock image
# requires the following files to be present:
# - $(BUILD_ARTIFACTS_PATH)/version.alpine.docker
# - $(BUILD_ARTIFACTS_PATH)/version.wiremock
build.wiremock.docker:
	$(eval DOCKERTAG=$(DOCKERREPO):$$(shell cat $(BUILD_ARTIFACTS_PATH)/version.wiremock))
	@printf -- "\n\033[32m\033[1mINFO: Using Docker Tag \"$(DOCKERTAG)\".\033[0m\n\n";
	docker build \
		--build-arg "ALPINE_VERSION=$$(cat $(BUILD_ARTIFACTS_PATH)/version.alpine.docker)" \
		--build-arg "WIREMOCK_VERSION=$$(cat $(BUILD_ARTIFACTS_PATH)/version.wiremock)" \
		--tag "$(DOCKERTAG)" \
	.
	docker tag "$(DOCKERTAG)" "$(DOCKERREGISTRY)/$(DOCKERTAG)"
	@printf -- "$(DOCKERTAG)\n" >> $(TAGS_LIST_PATH)

# retrieves the latest version of alpine available on dockerhub and places it into
# $(BUILD_ARTIFACTS_PATH)/version.alpine.docker
get.alpine.version.docker:
	-@mkdir -p $(BUILD_ARTIFACTS_PATH)
	@curl -s https://hub.docker.com/v2/repositories/library/alpine/tags/?page_size=100 \
		| jq -r '.results[].name' \
		| egrep '[0-9]+\.[0-9]+' \
		| sort -Vr \
		| head -n 1 \
		> $(BUILD_ARTIFACTS_PATH)/version.alpine.docker

# retrieves the latest version of wiremock available on dockerhub and places it into
# $(BUILD_ARTIFACTS_PATH)/version.wiremock
get.wiremock.version:
	-@mkdir -p $(BUILD_ARTIFACTS_PATH)
	@curl -s "https://api.github.com/repos/tomakehurst/wiremock/tags" \
		| jq '.[].name | match("[0-9]+.[0-9]+.[0-9]+") .string' -r \
		| head -n 1 \
		> $(BUILD_ARTIFACTS_PATH)/version.wiremock

# runs a test on the example to confirm everythings working
test:
	cd ./example && $(MAKE) test

# removes all built artifacts
clean:
	-@rm -rf $(BUILD_ARTIFACTS_PATH)
	-@rm -rf $(TAGS_LIST_PATH)

# logs an info message
log.info:
	@printf -- "\n\033[32m\033[1mINFO: ${MSG}\033[0m\n\n"