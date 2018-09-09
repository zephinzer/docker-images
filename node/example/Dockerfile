FROM zephinzer/node:8.11.4-alpine-dev
ARG USER_ID=1000
USER ${USER_ID}
WORKDIR /app
COPY ./package.json /app/package.json
RUN npm install
COPY . /app
ENTRYPOINT [ "nodemon", "src/main.js" ]
