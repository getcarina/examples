FROM node:0.10-onbuild

RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src

RUN apt-get update && apt-get install -y npm
RUN npm install restify
RUN npm install request

COPY productws.js productws.js

EXPOSE 8080

ENTRYPOINT node productws.js
