
# syntax=docker/dockerfile:1

FROM node:18.6.0-alpine3.15
ENV NODE_ENV=production

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install --production

COPY . .

CMD [ "node", "server.js" ]