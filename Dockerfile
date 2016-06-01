FROM kukuadev/concava:0.4
MAINTAINER Kukua Team <dev@kukua.cc>

RUN npm install request@2

COPY ./src/adapter.js src/adapter/contextBroker.js
