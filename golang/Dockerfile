ARG ALPINE_VERSION="3.8"
FROM alpine:${ALPINE_VERSION}
LABEL maintainer="dev@joeir.net" \
  version="1.0.0" \
  description="A minimal Go base image to build Go applications with."
ARG GO_VERSION="go1.9.3"
ENV APK_TO_INSTALL="bash curl git gcc g++ make linux-headers binutils-gold gnupg" \
  APK_TO_REMOVE="make linux-headers binutils-gold gnupg" \
  GO_REPO_URL="https://go.googlesource.com/go" \
  GO_VERSION_LAST_C_TOOLCHAIN="go1.4" \
  # this needs to be set or else go will complain
  GOROOT_BOOTSTRAP="/usr/local/go" \
  GOROOT="/usr/local/go" \
  GOPATH="/go" \
  PATHS_TO_REMOVE="\
    /tmp/* \
    /usr/share/man/* \
    /var/cache/apk/* \
    /root/.cache \
    /usr/local/go/.git \
    /usr/local/go/.gitattributes \
    /usr/local/go/.github \
    /usr/local/go/test \
    /usr/local/go/pkg/bootstrap \
    /usr/local/go/pkg/obj" \
  SYSTEM_BIN_PATH=/usr/local/bin/
WORKDIR /tmp
RUN apk add --update --upgrade --no-cache ${APK_TO_INSTALL} \
  && git clone ${GO_REPO_URL} \
  && cp -r go go1.4 \
  && cd /tmp/go1.4/src \
  && git checkout release-branch.${GO_VERSION_LAST_C_TOOLCHAIN} \
  && ./make.bash \
  && cd /tmp/go/src \
  && mv /tmp/go1.4 ${GOROOT_BOOTSTRAP} \
  && git checkout ${GO_VERSION} \
  && ./make.bash \
  && rm -rf ${GOROOT_BOOTSTRAP} \
  && mv /tmp/go ${GOROOT_BOOTSTRAP} \
  && ln -s ${GOROOT_BOOTSTRAP}/bin/go ${SYSTEM_BIN_PATH} \
  && ln -s ${GOROOT_BOOTSTRAP}/bin/gofmt ${SYSTEM_BIN_PATH} \
  && apk del --no-cache ${APK_TO_REMOVE} \
  && rm -rf ${PATHS_TO_REMOVE}
ARG USER_ID=1000
RUN adduser -H -D -u ${USER_ID} app \
  && mkdir -p /home/app/.cache \
  && mkdir -p /.cache \
  && chown app:app /.cache \
  && mkdir -p ${GOPATH}/src \
  && chown app:app ${GOPATH}/src \
  && mkdir -p ${GOPATH}/bin \
  && chown app:app ${GOPATH}/bin \
  && chmod 777 -R ${GOPATH} /.cache /home/app/.cache
# install dep dependency management tool
RUN curl -s https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
# install development tools concurrently
RUN go get -u -v github.com/golang/lint/golint \
  & go get -u -v github.com/oxequa/realize \
  & go get -v github.com/smartystreets/goconvey \
  & wait
ENV PATH "${PATH}:${GOROOT}/bin:${GOPATH}/bin"
WORKDIR ${GOPATH}/src
