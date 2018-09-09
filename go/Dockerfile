ARG TAG=latest
FROM golang:${TAG}
ARG USER_ID=1000
# install dependencies for dep/realize
RUN apk add --no-cache bash git curl
# install realize
RUN go get github.com/oxequa/realize
# install dep
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
RUN mkdir -p /.cache \
  && mkdir -p /go/src/app \
  && chmod 777 /.cache \
  && chmod 777 /go/src/app
USER ${USER_ID}
WORKDIR /go/src/app