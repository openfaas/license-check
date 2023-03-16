FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.19-alpine as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG GitCommit
ARG Version

ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOPATH=/go/src/
WORKDIR /go/src/github.com/openfaas/license-check

COPY main.go            .
COPY go.mod             .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go test -mod=vendor $(go list ./... | grep -v /vendor/) -cover

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags "-s -w -X main.GitCommit=${GitCommit} -X main.Version=${Version}" -o /usr/bin/license-check
RUN addgroup -S app \
    && adduser -S -g app app

FROM scratch

COPY --from=builder /etc/passwd /etc/group /etc/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/bin/license-check /

USER app

VOLUME /tmp/

ENTRYPOINT ["/license-check"]
CMD ["--help"]
