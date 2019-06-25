FROM ruby:2.5.5-alpine3.9

ARG WORK_DIR="/var/lib/volume/"

RUN mkdir ${WORK_DIR}

WORKDIR ${WORK_DIR}

RUN apk update
# RUN apk add --no-cache tzdata libxml2-dev curl-dev make gcc libc-dev g++ mariadb-dev
RUN apk add --no-cache tzdata
RUN apk add --no-cache libxml2-dev
RUN apk add --no-cache curl-dev
RUN apk add --no-cache make
RUN apk add --no-cache gcc
RUN apk add --no-cache libc-dev
RUN apk add --no-cache g++
RUN apk add --no-cache mariadb-dev

# デフォルトRailsプロジェクトのため
RUN apk add --no-cache sqlite
RUN apk add --no-cache sqlite-dev
# therubyrancerがalpine環境下だと動かないため
RUN apk add --no-cache nodejs

COPY ./docker/Gemfile ${WORK_DIR}
RUN bundle install
RUN rails new rails_test

# RUN apk del libxml2-dev curl-dev make gcc libc-dev g++
EXPOSE  3000
