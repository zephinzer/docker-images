build:
	cd ./golang && $(MAKE) build
	cd ./node && $(MAKE) build

test: 
	cd ./golang && $(MAKE) test

publish:
	cd ./golang && $(MAKE) publish
	cd ./node && $(MAKE) publish