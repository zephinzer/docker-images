FROM zephinzer/go:1.11
ARG USER_ID=1000
USER ${USER_ID}
WORKDIR /go/src/app
COPY . /go/src/app
ENTRYPOINT [ "realize", "start", "--run", "main.go" ]