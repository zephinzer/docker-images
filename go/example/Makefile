PROJECT_NAME=$$(basename $$(pwd))

build:
	docker build --build-arg PROJECT_NAME=$(PROJECT_NAME) -t app .

compile:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" app go build -o app

init:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" app dep init \
		|| docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" app dep ensure

run:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" app realize start --run main.go

clean.eg:
	@rm -rf vendor .realize.yaml app Gopkg.*