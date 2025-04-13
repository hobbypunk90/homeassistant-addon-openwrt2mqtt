# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add build-base ruby ruby-dev yaml yaml-dev sqlite curl

ENV SECRET_KEY_BASE="DUMMY" \
    RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Copy root filesystem
COPY rootfs /

WORKDIR /opt/openwrt2mqtt
RUN gem update --system \
 && gem install bundler \
 && bundle install
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

ENV HEALTH_PORT="3000" \
    HEALTH_URL="/up"
HEALTHCHECK \
    --interval=5s \
    --retries=5 \
    --start-period=30s \
    --timeout=25s \
    CMD curl -A "HealthCheck: Docker/1.0" -s -f "http://127.0.0.1:${HEALTH_PORT}${HEALTH_URL}" &>/dev/null || exit 1