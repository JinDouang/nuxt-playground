FROM node:16-alpine

WORKDIR /usr/src/app
COPY . .

RUN npm install
RUN npm run build

ENV HOST 0.0.0.0
