FROM ruby:2.5.5-alpine3.9

ARG WORK_DIR="/var/lib/volume/"

RUN mkdir ${WORK_DIR}

WORKDIR ${WORK_DIR}

RUN apk update
RUN apk add --no-cache tzdata libxml2-dev curl-dev make gcc libc-dev g++ mariadb-dev

# Gem : therubyrancerがalpine環境下だと動かないため
RUN apk add --no-cache nodejs

# RedisのBundlerのインストール先(このディレクトリをdockerの共有ディレクトリとして指定して永続化する)
ENV BUNDLE_PATH=/bundle

# RUN apk del libxml2-dev curl-dev make gcc libc-dev g++
EXPOSE  3000
