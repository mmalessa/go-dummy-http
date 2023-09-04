FROM golang:1.21-alpine3.18 AS base
RUN apk update && apk upgrade
RUN apk add --no-cache bash git openssh autoconf automake libtool gettext gettext-dev make g++ texinfo curl
RUN mkdir /go/pkg
RUN chmod a+rwx /go/pkg
WORKDIR /go/src/app


FROM base AS dev
ARG DEVELOPER_UID
RUN adduser -s /bin/sh -u ${DEVELOPER_UID} -D developer
USER developer
WORKDIR /go/src/app


FROM base AS build
WORKDIR /go/src/app
COPY . .
RUN go build -buildvcs=false -o bin/server


FROM alpine:3.18 AS prod
COPY --from=build /go/src/app/bin/server /usr/local/bin/go-dummy-server
ENTRYPOINT /usr/local/bin/go-dummy-server $APP_INSTANCE