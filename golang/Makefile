# make a copy of `./sample.properties` file  as `./Makefile.properties`
include ../Makefile.properties

# general paths so we don't need to keep retyping
DOCKERREPO=$(DOCKERUSER)/golang
TAGS_LIST_PATH=./.make.build.tags
BUILD_ARTIFACTS_PATH=./.make.build.go

# run all possible builds
build:
	-@rm -rf $(TAGS_LIST_PATH)
	$(MAKE) build.go

# publish everything
publish: build
	-@touch $(TAGS_LIST_PATH)
	@cat ./$(TAGS_LIST_PATH) | xargs -P 10 -I@ $(MAKE) TAG="@" publish.dockerhub
	-@rm -rf $(TAGS_LIST_PATH)

# build driver for go - call this to initialise pre-requisites for build.go.docker and run the build
build.go:
	-@mkdir $(BUILD_ARTIFACTS_PATH)
	$(MAKE) get.go.version.go
	@printf -- "\n\033[32m\033[1mINFO: Go at version $$(cat $(BUILD_ARTIFACTS_PATH)/version.go) was found from Golang download page.\033[0m\n\n";
	$(MAKE) get.alpine.version.docker
	@printf -- "\n\033[32m\033[1mINFO: Alpine at version $$(cat $(BUILD_ARTIFACTS_PATH)/version.alpine.docker) was found on DockerHub.\033[0m\n\n";
	$(MAKE) build.go.docker
	-@rm -rf $(BUILD_ARTIFACTS_PATH)

# publishes this image with additional tagging to dockerhub
publish.dockerhub:
	$(eval VERSION_DEP=$$(shell docker run ${TAG} dep version | egrep -oi 'v[0-9]+\.[0-9]+\.*[0-9]*' | sed 's|v||g'))
	@printf -- "\n\033[32m\033[1mINFO: Dep is at version $(VERSION_DEP).\033[0m\n\n";
	$(eval VERSION_REALIZE=$$(shell docker run ${TAG} realize version - | egrep -oi '[0-9]+\.[0-9]+\.*[0-9]*'))
	@printf -- "\n\033[32m\033[1mINFO: Realize is at version $(VERSION_REALIZE).\033[0m\n\n";
	docker tag ${TAG} $(DOCKERREGISTRY)/${TAG}
	@printf -- "\n\033[32m\033[1mINFO: Pushing canonical tag...\033[0m\n\n";
	docker push $(DOCKERREGISTRY)/${TAG}
	docker tag ${TAG} ${TAG}-dep${VERSION_DEP}-realize$(VERSION_REALIZE)
	@printf -- "\n\033[32m\033[1mINFO: Pushing detailed tag...\033[0m\n\n";
	docker push ${TAG}-dep${VERSION_DEP}-realize$(VERSION_REALIZE)
	docker tag ${TAG} $(DOCKERREGISTRY)/$(DOCKERREPO):latest
	@printf -- "\n\033[32m\033[1mINFO: Pushing latest tag...\033[0m\n\n";
	docker push $(DOCKERREGISTRY)/$(DOCKERREPO):latest

# builds the actual golang image
# requires the following files to be present:
# - $(BUILD_ARTIFACTS_PATH)/version.alpine.docker
# - $(BUILD_ARTIFACTS_PATH)/version.go
build.go.docker:
	$(eval DOCKERTAG=$(DOCKERREPO):$$(shell cat $(BUILD_ARTIFACTS_PATH)/version.go))
	@printf -- "\n\033[32m\033[1mINFO: Using Docker Tag \"$(DOCKERTAG)\".\033[0m\n\n";
	docker build \
		--build-arg "ALPINE_VERSION=$$(cat $(BUILD_ARTIFACTS_PATH)/version.alpine.docker)" \
		--build-arg "GO_VERSION=go$$(cat $(BUILD_ARTIFACTS_PATH)/version.go)" \
		--tag "$(DOCKERTAG)" \
	.
	docker tag "$(DOCKERTAG)" "$(DOCKERREGISTRY)/$(DOCKERTAG)"
	@printf -- "$(DOCKERTAG)\n" >> $(TAGS_LIST_PATH)

# retrieves the latest version of alpine available on dockerhub and places it into
# $(BUILD_ARTIFACTS_PATH)/version.alpine.docker
get.alpine.version.docker:
	@curl -s https://hub.docker.com/v2/repositories/library/alpine/tags/?page_size=100 \
		| jq -r '.results[].name' \
		| egrep '[0-9]+\.[0-9]+' \
		| sort -Vr \
		| head -n 1 \
		> $(BUILD_ARTIFACTS_PATH)/version.alpine.docker

# retrieves the latest version of golang and places it into
# $(BUILD_ARTIFACTS_PATH)/version.go
get.go.version.go:
	@mkdir -p $(BUILD_ARTIFACTS_PATH)
	$(eval REGEX_SEMVER=[0-9]+\.[0-9]+\.*[0-9]*)
	@curl -s https://golang.org/dl/ \
		| egrep -oi "go$(REGEX_SEMVER)" \
		| egrep -oi "$(REGEX_SEMVER)" \
		| egrep '^.+[0-9]$$' \
		| sort -uVr \
		| head -n 1 \
		> $(BUILD_ARTIFACTS_PATH)/version.go

test: build
	@cd ./example && $(MAKE) build
	@stat ./.make.build.tags
	-@rm -rf .make.build.tags
	@cd ./example && $(MAKE) init
	@stat ./example/vendor
	@stat ./example/Gopkg.lock
	@stat ./example/Gopkg.toml
	@cd ./example && $(MAKE) compile
	@stat ./example/example
	-@cd ./example && $(MAKE) test
	@stat ./example/coverage.out
	@cd ./example && $(MAKE) clean
