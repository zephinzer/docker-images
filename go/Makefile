include ../Makefile.properties

DOCKERREPO=$(DOCKERUSER)/go
TAGS_LIST_PATH=./.make.build.tags
BUILD_ARTIFACTS_PATH=./.make.build.go

build:
	-@rm -rf $(TAGS_LIST_PATH)
	$(MAKE) build.go

publish: build
	-@touch $(TAGS_LIST_PATH)
	@cat ./$(TAGS_LIST_PATH) | xargs -P 10 -I@ docker push @
	-@rm -rf $(TAGS_LIST_PATH)

build.go:
	-@mkdir $(BUILD_ARTIFACTS_PATH)
	$(MAKE) get.go.version.go
	$(MAKE) get.go.tags
	$(MAKE) get.go.version.docker
	@if [ "$$(cat $(BUILD_ARTIFACTS_PATH)/version.docker)" != "null" ]; then \
		printf -- "\n\033[32m\033[1mINFO: Golang at version $$(cat $(BUILD_ARTIFACTS_PATH)/version.go) was found on DockerHub.\033[0m\n\n"; \
		$(MAKE) build.go.docker; \
	else \
		printf -- "\n\033[31m\033[1mERR: Golang at version $$(cat $(BUILD_ARTIFACTS_PATH)/version.go) was NOT FOUND on DockerHub.\033[0m\n\n"; \
	fi
	-@rm -rf $(BUILD_ARTIFACTS_PATH)

build.go.docker:
	$(eval DOCKERTAG=$(DOCKERREPO):$$(shell cat $(BUILD_ARTIFACTS_PATH)/version.go)) \
	docker build \
		--build-arg "TAG=$$(cat $(BUILD_ARTIFACTS_PATH)/version.go)-alpine" \
		--tag "$(DOCKERTAG)" \
	.
	docker tag "$(DOCKERTAG)" "$(DOCKERREGISTRY)/$(DOCKERTAG)"
	printf -- "$(DOCKERTAG)\n" >> $(TAGS_LIST_PATH)

get.go.tags:
	$(eval TAG=$$(shell cat $(BUILD_ARTIFACTS_PATH)/version.go))
	@curl -s \
		https://hub.docker.com/v2/repositories/library/golang/tags/$(TAG)-alpine/ \
		> $(BUILD_ARTIFACTS_PATH)/tags

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

get.go.version.docker:
	@cat $(BUILD_ARTIFACTS_PATH)/tags \
		| jq -r '.name' \
		> $(BUILD_ARTIFACTS_PATH)/version.docker

