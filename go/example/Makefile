build:
	docker build --build-arg USER_ID=$$(id -u $(whoami)) -t app .

compile:
	docker run -v "$$(pwd):/go/src/app" app go build -o app

init:
	docker run -v "$$(pwd):/go/src/app" app dep init \
		|| docker run -v "$$(pwd):/go/src/app" app dep ensure

run:
	docker run -v "$$(pwd):/go/src/app" app realize start --run main.go

clean.eg:
	@rm -rf vendor .realize.yaml app Gopkg.*