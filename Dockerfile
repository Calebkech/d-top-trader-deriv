FROM node:22-bookworm-slim AS builder

WORKDIR /app
COPY package.json package-lock.json ./
COPY packages ./packages
COPY scripts ./scripts
COPY types ./types
COPY assets ./assets
COPY babel.config.json brand.config.json tsconfig.json ./.prettierrc ./

RUN npm ci --ignore-scripts
RUN npm run build:all

FROM nginx:alpine
COPY --from=builder /app/packages/core/dist /usr/share/nginx/html
COPY ./default.conf /etc/nginx/conf.d/default.conf
RUN chown -R nginx:nginx /usr/share/nginx/html

