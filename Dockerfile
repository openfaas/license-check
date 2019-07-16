FROM golang:1.10.4-alpine as builder

RUN apk add --no-cache make

WORKDIR /go/src/github.com/teamserverless/license-check
COPY . .

RUN make

FROM alpine:3.9

WORKDIR /root/

COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check .
COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check-darwin .
COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check-armhf .
COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check-arm64 .
COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check-s390x .
COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check-ppc64le .
