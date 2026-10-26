Version := $(shell git describe --tags --dirty)
GitCommit := $(shell git rev-parse HEAD)

ifndef Version
override Version = dev
endif

SERVER?=ttl.sh
OWNER?=openfaasltd
IMG_NAME?=license-check
TAG?=$(Version)

PLATFORM?=linux/amd64,linux/arm64

export DOCKER_CLI_EXPERIMENTAL=enabled

LDFLAGS:="-s -w -X main.Version=$(Version) -X main.GitCommit=$(GitCommit)"

.PHONY: all
all: docker

.PHONY: lint
lint:
	test -z "$(shell gofmt -s -l ./)" || (echo "Formatting errors, run \"gofmt -s -w ./\"" && exit 1)

.PHONY: test
test:
	go test ./...

.PHONY: dist
dist:
	CGO_ENABLED=0 GOOS=linux go build --ldflags $(LDFLAGS) -o bin/license-check
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build --ldflags $(LDFLAGS) -o bin/license-check-arm64

.PHONY: docker
docker:
	@docker buildx build \
		--load \
		--build-arg Version=$(Version) --build-arg GitCommit=$(GitCommit) \
		--platform linux/amd64 \
		--tag ${SERVER}/${OWNER}/$(IMG_NAME):$(TAG) .

.PHONY: push-buildx
push-buildx:
	@echo $(SERVER)/$(OWNER)/$(IMG_NAME):$(TAG) && \
	docker buildx create --use --name=multiarch --node=multiarch && \
	docker buildx build \
		--push \
		--platform $(PLATFORM) \
		--build-arg Version=$(Version) --build-arg GitCommit=$(GitCommit) \
		--tag $(SERVER)/$(OWNER)/$(IMG_NAME):$(TAG) \
		.

.PHONY: clean
clean:
	rm -rf bin/
