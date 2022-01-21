Version := $(shell git describe --tags --dirty)
GitCommit := $(shell git rev-parse HEAD)
LDFLAGS := "-s -w -X main.Version=$(Version) -X main.GitCommit=$(GitCommit)"

# docker manifest command will work with Docker CLI 18.03 or newer
# but for now it's still experimental feature so we need to enable that
export DOCKER_CLI_EXPERIMENTAL=enabled

.PHONY: all
all: docker

.PHONY: lint
lint:
	test -z $(shell gofmt -e -l ./) || echo "Formatting errors, run \"gofmt -s -w ./\""

.PHONY: test
test:
	go test ./...

.PHONY: dist
dist:
	CGO_ENABLED=0 GOOS=linux go build -ldflags $(LDFLAGS) -a -installsuffix cgo -o bin/license-check
	CGO_ENABLED=0 GOOS=darwin go build -ldflags $(LDFLAGS) -a -installsuffix cgo -o bin/license-check-darwin
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags $(LDFLAGS) -a -installsuffix cgo -o bin/license-check.exe
	CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=6 go build -ldflags $(LDFLAGS) -a -installsuffix cgo -o bin/license-check-armhf
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags $(LDFLAGS) -a -installsuffix cgo -o bin/license-check-arm64

.PHONY: docker
docker:
	@docker buildx create --use --name=multiarch --node multiarch && \
	docker buildx build \
		--progress=plain \
		--build-arg VERSION=$(Version) --build-arg GIT_COMMIT=$(GitCommit) \
		--platform linux/amd64,linux/arm/v6,linux/arm64 \
		--output "type=image,push=false" \
		--tag ${DOCKER_NS}/license-check:$(Version) .

.PHONY: docker-login
docker-login:
	echo -n "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin

.PHONY: push
push:
	@docker buildx create --use --name=multiarch --node multiarch && \
	docker buildx build \
		--progress=plain \
		--build-arg VERSION=$(Version) --build-arg GIT_COMMIT=$(GitCommit) \
		--platform linux/amd64,linux/arm/v6,linux/arm64 \
		--output "type=image,push=true" \
		--tag ${DOCKER_NS}/license-check:$(Version) .
