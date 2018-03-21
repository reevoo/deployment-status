FROM quay.io/assemblyline/alpine:3.7 as dev

ENV APP_NAME=deployment-status \
    BUNDLE_SILENCE_ROOT_WARNING=1

WORKDIR /app

COPY .ruby-version ./

RUN apk add --no-cache \
      build-base \
      ca-certificates \
      curl \
      git \
      libxml2-dev \
      libxslt-dev \
      postgresql-client \
      postgresql-dev \
      ruby$(cat .ruby-version) \
      ruby$(cat .ruby-version)-dev

COPY Gemfile Gemfile.lock ./
RUN bundle install -j4 -r3
COPY . .

FROM dev as build
RUN bundle install -j4 -r3 --system --frozen --without development test \
 && bundle clean --force \
 && curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o /app/config/rds-combined-ca-bundle.pem \
 && scanelf --needed --nobanner --recursive /usr/lib/ruby/gems \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u \
      | xargs -r apk info --installed \
      | sort -u > .rundeps \
 && rm -rf \
      .git \
      /usr/lib/ruby/gems/*/cache \
      Dockerfile \
      Jenkinsfile \
      coverage \
      log \
      spec \
      tmp

FROM quay.io/assemblyline/alpine:3.7
ENV APP_NAME=deployment-status \
    RACK_ENV=production \
    PGSSLROOTCERT=/app/config/rds-combined-ca-bundle.pem

WORKDIR /app

COPY --from=build /app/.ruby-version /app/.rundeps ./
RUN apk add --no-cache \
      ca-certificates \
      ruby$(cat .ruby-version) \
      $(cat .rundeps)

COPY --from=build /usr/lib/ruby/gems/ /usr/lib/ruby/gems/
RUN ruby -e "Gem::Specification.map.each { |spec| Gem::Installer.for_spec(spec, wrappers: true, force: true, install_dir: spec.base_dir, build_args: spec.build_args).generate_bin }"

COPY --from=build /app/ .
USER nobody
