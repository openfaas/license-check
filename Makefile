.GIT_COMMIT=$(shell git rev-parse HEAD)

export CGO_ENABLED=0

.PHONY: all
all: linux darwin armhf arm64 s390x ppc64le windows

.PHONY: linux
linux:
	GOOS=linux go build -o license-check --ldflags "-s -w \
	-X main.GitCommit=${.GIT_COMMIT}" \
	-a -installsuffix cgo

.PHONY: darwin
darwin:
	GOOS=darwin go build -o license-check-darwin --ldflags "-s -w \
	-X main.GitCommit=${.GIT_COMMIT}" \
	-a -installsuffix cgo

.PHONY: armhf
armhf:
	GOOS=linux GOARCH=arm GOARM=6 go build -o license-check-armhf --ldflags "-s -w \
	-X main.GitCommit=${.GIT_COMMIT}" \
	-a -installsuffix cgo

.PHONY: arm64
arm64:
	GOOS=linux GOARCH=arm64 go build -o license-check-arm64 --ldflags "-s -w \
	-X main.GitCommit=${.GIT_COMMIT}" \
	-a -installsuffix cgo

.PHONY: s390x
s390x:
	GOOS=linux GOARCH=s390x go build -o license-check-s390x --ldflags "-s -w \
	-X main.GitCommit=${.GIT_COMMIT}" \
	-a -installsuffix cgo

.PHONY: ppc64le
ppc64le:
	GOOS=linux GOARCH=ppc64le go build -o license-check-ppc64le --ldflags "-s -w \
	-X main.GitCommit=${.GIT_COMMIT}" \
	-a -installsuffix cgo

.PHONY: windows
windows:
	GOOS=windows go build -o license-check.exe  --ldflags "-s -w \
	-X main.GitCommit=${.GIT_COMMIT}" \
	-a -installsuffix cgo
