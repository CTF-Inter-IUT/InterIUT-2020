FROM node:lts-alpine

COPY . /app

WORKDIR /app

RUN yarn 

RUN yarn build

EXPOSE 80

CMD ["node", "dist/server.js"]
