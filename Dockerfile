FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.15-alpine as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG GIT_COMMIT
ARG VERSION

ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOPATH=/go/src/
WORKDIR /go/src/github.com/inlets/inlets

COPY .git               .git
COPY main.go            .
COPY go.mod             .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go test -mod=vendor $(go list ./... | grep -v /vendor/) -cover

# add user in this stage because it cannot be done in next stage which is built from scratch
# in next stage we'll copy user and group information from this stage
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags "-s -w -X main.GitCommit=${GIT_COMMIT} -X main.Version=${VERSION}" -a -installsuffix cgo -o /usr/bin/license-check \
    && addgroup -S app \
    && adduser -S -g app app

FROM scratch

COPY --from=builder /etc/passwd /etc/group /etc/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/bin/license-check /

USER app

VOLUME /tmp/

ENTRYPOINT ["/license-check"]
CMD ["--help"]
