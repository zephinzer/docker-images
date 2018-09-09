ARG TAG=latest
FROM golang:${TAG}
WORKDIR /go
RUN apk add --no-cache bash git curl
RUN go get github.com/oxequa/realize
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
RUN mkdir -p /.cache \
  && chmod 777 /.cache