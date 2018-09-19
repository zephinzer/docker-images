build:
	cd ./golang && $(MAKE) build
	cd ./node && $(MAKE) build
	cd ./wiremock && $(MAKE) build

test: 
	cd ./golang && $(MAKE) test
	cd ./wiremock && $(MAKE) test

publish:
	cd ./golang && $(MAKE) publish
	cd ./node && $(MAKE) publish
	cd ./wiremock && $(MAKE) publish