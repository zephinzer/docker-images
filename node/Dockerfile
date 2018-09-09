ARG TAG=latest-alpine
FROM node:${TAG} as production
WORKDIR /app

ARG TAG=latest-alpine
FROM node:${TAG} as development
RUN apk add --no-cache bash curl gcc g++ make python linux-headers binutils-gold libstdc++ gnupg
RUN npm install -g nodemon
WORKDIR /app
RUN chmod 777 /app