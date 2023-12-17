FROM node:18.19.0-alpine3.19

WORKDIR /usr/src/app

COPY ./ ./

RUN npm install
RUN npm run build

EXPOSE 4000

CMD ["node", "dist/main"]