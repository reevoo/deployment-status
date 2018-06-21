FROM ruby:2.5.1-alpine3.7 as dev

ENV APP_NAME=deployment-status

RUN apk add --no-cache \
    ca-certificates \
    postgresql-client \
 && apk add --no-cache --virtual .build-deps \
    build-base \
    git \
    bash \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    curl

ENV BUNDLE_SILENCE_ROOT_WARNING=1

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install -j4 -r3

COPY . .


FROM dev

ENV RAILS_ENV=production
ENV PGSSLROOTCERT=/app/config/rds-combined-ca-bundle.pem

RUN curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o /app/config/rds-combined-ca-bundle.pem

RUN bundle install -j4 -r3 --system --frozen --without development test \
 && bundle clean --force \
 && apk del .build-deps \
 && rm -rf \
      .git \
      /usr/lib/ruby/gems/*/cache \
      /var/cache/apk/* \
      /tmp/* \
      /var/tmp/* \
      Dockerfile \
      coverage \
      log \
      spec

USER nobody
