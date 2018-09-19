ARG ALPINE_VERSION="3.7"
FROM alpine:${ALPINE_VERSION}
LABEL maintainer="dev@joeir.net" \
  version="1.0.0" \
  description="A minimal Go base image to build Go applications with."
ARG WIREMOCK_VERSION="2.18.0"
ENV APK_TO_INSTALL="bash curl openjdk8-jre-base" \
  APK_TO_REMOVE="" \
  WIREMOCK_DOWNLOAD_URL="https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-standalone/${WIREMOCK_VERSION}/wiremock-standalone-${WIREMOCK_VERSION}.jar" \
  PATHS_TO_REMOVE="\
  /tmp/* \
  /usr/include/* \
  /usr/share/man/* \
  /var/cache/apk/*" \
  SYSTEM_BIN_PATH=/usr/local/bin/
WORKDIR /tmp
USER root
RUN apk add --update --upgrade --no-cache ${APK_TO_INSTALL} \
  && curl -sSL \
  -o ./wiremock.jar \
  "${WIREMOCK_DOWNLOAD_URL}" \
  && mkdir -p /app \
  && cp -r /tmp/* /app \
  && apk del ${APK_TO_REMOVE} \
  && rm -rf ${PATHS_TO_REMOVE}
WORKDIR /app
VOLUME ["/app/mappings", "/app/__files"]
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/wiremock.jar"]
