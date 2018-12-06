all: linux darwin arm arm64

linux:
	GOOS=linux go build -o license-check --ldflags "-s -w" -a -installsuffix cgo
arm:
	GOOS=linux GOARCH=arm GOARM=6 go build -o license-check-armhf --ldflags "-s -w" -a -installsuffix cgo
darwin:
	GOOS=darwin go build -o license-check-darwin --ldflags "-s -w" -a -installsuffix cgo
arm64:
	GOOS=linux GOARCH=arm64 go build -o license-check-arm64 --ldflags "-s -w" -a -installsuffix cgo
