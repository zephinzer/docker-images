include ../Makefile.properties

DOCKERREPO=$(DOCKERUSER)/node
TAGS_LIST_PATH=./.make.build.tags
BUILD_ARTIFACTS_PATH=./.make.build.node

build:
	-@rm -rf $(TAGS_LIST_PATH)
	$(MAKE) V=4 build.node & \
	$(MAKE) V=6 build.node & \
	$(MAKE) V=10 build.node & \
	$(MAKE) V=8 build.node & \
	wait

publish: build
	-@touch $(TAGS_LIST_PATH)
	@cat ./$(TAGS_LIST_PATH) | xargs -P 10 -I@ docker push @
	-@rm -rf $(TAGS_LIST_PATH)

# V: node major version
build.node:
	-@mkdir $(BUILD_ARTIFACTS_PATH)${V}
	$(MAKE) V=${V} get.node.version.node
	$(MAKE) V=${V} get.node.tags
	$(MAKE) V=${V} get.node.version.docker
	@if [ "$$(cat $(BUILD_ARTIFACTS_PATH)${V}/version.docker)" != "null" ]; then \
		printf -- "\n\033[32m\033[1mINFO: Node at version $$(cat $(BUILD_ARTIFACTS_PATH)${V}/version.node) was found on DockerHub.\033[0m\n\n"; \
		$(MAKE) ENV=production TAG_POSTFIX= V=${V} build.node.env; \
		$(MAKE) ENV=development TAG_POSTFIX=-dev V=${V} build.node.env; \
	else \
		printf -- "\n\033[31m\033[1mERR: Node at version $$(cat $(BUILD_ARTIFACTS_PATH)${V}/version.node) was NOT FOUND on DockerHub.\033[0m\n\n"; \
	fi;
	@rm -rf $(BUILD_ARTIFACTS_PATH)${V}

# V: node major version
get.node.version.node:
	@curl -s https://nodejs.org/dist/latest-v${V}.x/ \
		| grep "a href" \
		| grep ".pkg" \
		| cut -f 2 -d '"' \
		| sed 's|node\-v||g' \
		| sed 's|.pkg||g' \
		> $(BUILD_ARTIFACTS_PATH)${V}/version.node

# V: node major version
get.node.version.docker:
	@cat $(BUILD_ARTIFACTS_PATH)${V}/tags \
		| jq -r '.name' \
		> $(BUILD_ARTIFACTS_PATH)${V}/version.docker

# V: node major version
get.node.tags:
	$(eval TAG="$$(shell cat $(BUILD_ARTIFACTS_PATH)${V}/version.node)")
	@curl -s \
		https://hub.docker.com/v2/repositories/library/node/tags/$(TAG)-alpine/ \
		> $(BUILD_ARTIFACTS_PATH)${V}/tags

# ENV: development|production
# TAG_POSTFIX: additional tag behind the image tag
# V: node major version
build.node.env:
	$(eval DOCKERTAG=$(DOCKERREPO):$$(shell cat $(BUILD_ARTIFACTS_PATH)${V}/version.node)${TAG_POSTFIX})
	docker build \
		--target ${ENV} \
		--build-arg "TAG=$$(cat $(BUILD_ARTIFACTS_PATH)${V}/version.docker)" \
		--tag "$(DOCKERTAG)" \
	.
	docker tag "$(DOCKERTAG)" "$(DOCKERREGISTRY)/$(DOCKERTAG)"
	printf -- "$(DOCKERTAG)\n" >> $(TAGS_LIST_PATH)
