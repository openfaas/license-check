FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.27.3-alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG GitCommit
ARG Version

ENV CGO_ENABLED=0
ENV GO111MODULE=on

WORKDIR /go/src/github.com/openfaas/license-check

COPY go.mod main.go main_test.go ./

RUN CGO_ENABLED=0 go test -cover ./...

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build \
        --ldflags "-s -w -X main.GitCommit=${GitCommit} -X main.Version=${Version}" \
        -o /usr/bin/license-check

FROM gcr.io/distroless/static:nonroot AS ship

LABEL org.label-schema.license="MIT" \
      org.label-schema.vcs-url="https://github.com/openfaas/license-check" \
      org.label-schema.vcs-type="Git" \
      org.label-schema.name="openfaas/license-check" \
      org.label-schema.vendor="openfaas" \
      org.label-schema.docker.schema-version="1.0"

COPY --from=build /usr/bin/license-check /usr/bin/

USER nonroot

ENTRYPOINT ["/usr/bin/license-check"]
CMD ["--help"]
