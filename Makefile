build:
	cd ./go && $(MAKE) build
	cd ./node && $(MAKE) build

publish:
	cd ./go && $(MAKE) publish
	cd ./node && $(MAKE) publish