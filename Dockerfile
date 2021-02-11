FROM openjdk:nanoserver
WORKDIR /usr/src/app
RUN apk add --no-cache npm nodejs && apt-get update &&\
    apk add --no-cache bash
USER node

