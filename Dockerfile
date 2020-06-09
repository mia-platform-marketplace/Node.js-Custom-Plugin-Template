FROM node:12.3.1-alpine as build

ARG COMMIT_SHA=<not-specified>
ENV NODE_ENV=production

WORKDIR /build-dir

COPY package.json .
COPY package-lock.json .

RUN npm ci

COPY . .

RUN echo "mia_template_service_name_placeholder: $COMMIT_SHA" >> ./commit.sha

########################################################################################################################

FROM node:12.3.1-alpine

LABEL maintainer="%CUSTOM_PLUGIN_CREATOR_USERNAME%" \
      name="mia_template_service_name_placeholder" \
      description="%CUSTOM_PLUGIN_SERVICE_DESCRIPTION%" \
      eu.mia-platform.url="https://www.mia-platform.eu" \
      eu.mia-platform.version="0.1.0"

ENV NODE_ENV=production
ENV LOG_LEVEL=info
ENV SERVICE_PREFIX=/
ENV HTTP_PORT=3000

WORKDIR /home/node/app

COPY --from=build /build-dir ./

USER node

CMD ["npm", "-s", "start", "--", "--options", "--port", "${HTTP_PORT}", "--log-level", "${LOG_LEVEL}", "--prefix=${SERVICE_PREFIX}", "--address", "0.0.0.0"]
