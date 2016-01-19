FROM kukuadev/concava:0.4
MAINTAINER Maurits van Mastrigt <maurits@kukua.cc>

COPY ./src/adapter.js src/adapter/contextBroker.js

RUN npm install request@2
