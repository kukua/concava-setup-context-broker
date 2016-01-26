FROM kukuadev/concava:0.4
MAINTAINER Maurits van Mastrigt <maurits@kukua.cc>

RUN npm install request@2

COPY ./src/adapter.js src/adapter/contextBroker.js
