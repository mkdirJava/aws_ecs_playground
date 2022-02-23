FROM node:17.5.0-alpine3.15
# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

CMD [ "node", "server.js" ]