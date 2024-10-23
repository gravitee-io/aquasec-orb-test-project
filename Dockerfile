FROM node:20-alpine as production-builder

ENV APP_PATH /app
WORKDIR $APP_PATH

# Ensure to install deps only if the package.json has been modified
COPY package.json .yarnrc.yml yarn.lock ./

RUN corepack enable && yarn workspaces focus --production

FROM node:20-alpine as production

ENV APP_PATH /app
ENV NODE_ENV production
WORKDIR $APP_PATH

USER node
COPY --chown=node:node ../dist $APP_PATH/dist
COPY --chown=node:node --from=production-builder $APP_PATH/node_modules $APP_PATH/node_modules

CMD ["node", "./dist/main.js"]
