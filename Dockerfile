FROM golang:1.13 as builder

WORKDIR /go/src/github.com/teamserverless/license-check
COPY . .

RUN make

FROM scratch

WORKDIR /root/

COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check .
COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check-darwin .
COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check-armhf .
COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check-arm64 .
COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check-s390x .
COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check-ppc64le .
COPY --from=builder /go/src/github.com/teamserverless/license-check/license-check.exe .
