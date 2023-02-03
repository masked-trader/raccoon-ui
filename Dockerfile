FROM node:18 as node-base

WORKDIR /workspace

COPY package.json \
    yarn.lock \
    /workspace/

RUN corepack enable
RUN yarn set version berry

ENV YARN_ENABLE_GLOBAL_CACHE=false \
    YARN_NODE_LINKER=node-modules \
    YARN_NM_MODE=hardlinks-local

RUN yarn

FROM node-base as builder-base

WORKDIR /workspace

ENV YARN_ENABLE_GLOBAL_CACHE=false \
    YARN_NODE_LINKER=node-modules \
    YARN_NM_MODE=hardlinks-local \
    NODE_ENV=production

COPY src/ /workspace/src/
COPY public/ /workspace/public/

COPY tsconfig.json \
    /workspace/

RUN yarn build

FROM builder-base as production

WORKDIR /workspace

EXPOSE 3000

ENV NODE_ENV production

CMD [ "yarn", "dlx", "serve", "build"]
