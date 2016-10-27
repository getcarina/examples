FROM node:latest
MAINTAINER Don Schenck "don.schenck@gmail.com"


RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src

RUN apt-get update
#RUN apt-get install -y npm
#RUN yum install npm
RUN npm install restify
RUN npm install request
RUN npm install mongodb

COPY package.json package.json
COPY productws.js productws.js

EXPOSE 8080

CMD node productws.js
