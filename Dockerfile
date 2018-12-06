FROM golang:1.9.2-alpine as builder

RUN apk add --no-cache make

WORKDIR /go/src/github.com/alexellis/license-check
COPY . .

RUN make

FROM alpine:3.7

WORKDIR /root/

COPY --from=builder /go/src/github.com/alexellis/license-check/license-check
COPY --from=builder /go/src/github.com/alexellis/license-check/license-check-darwin
COPY --from=builder /go/src/github.com/alexellis/license-check/license-check-armhf
COPY --from=builder /go/src/github.com/alexellis/license-check/license-check-arm64

