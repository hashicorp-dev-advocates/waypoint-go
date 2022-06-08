FROM golang:latest as build

RUN mkdir -p /go/src/github.com/nicholasjackson/canary-deploys/apps/api
COPY . /go/src/github.com/nicholasjackson/canary-deploys/apps/api
WORKDIR /go/src/github.com/nicholasjackson/canary-deploys/apps/api

RUN go get ./... && CGO_ENABLED=0 GOOS=linux go build -o ./bin/api

FROM alpine:latest 

RUN apk add --no-cache curl bash

ARG TARGETARCH

COPY --from=build /go/src/github.com/nicholasjackson/canary-deploys/apps/api/bin/api /bin/api

ENTRYPOINT [ "/bin/api" ]
