#!/bin/sh
set -xe

# runs on code / no need db
bundle exec reevoocop

bundle exec bundle-audit check --update
