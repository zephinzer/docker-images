build:
	cd ./golang && $(MAKE) build
	cd ./node && $(MAKE) build

publish:
	cd ./golang && $(MAKE) publish
	cd ./node && $(MAKE) publish