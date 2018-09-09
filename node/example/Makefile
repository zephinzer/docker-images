build:
	docker build --build-arg USER_ID=$$(id -u $(whoami)) -t app .

init:
	docker run -v "$$(pwd)/src:/app/src" --entrypoint=npm app install

run:
	docker run -v "$$(pwd)/src:/app/src" app nodemon src/main.js

clean.eg:
	@rm -rf node_modules