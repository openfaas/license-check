all: linux darwin arm

linux:
	GOOS=linux go build -o license-check --ldflags "-s -w" -a -installsuffix cgo
arm:
	GOOS=linux GOARCH=arm GOARM=6 go build -o license-check-armhf --ldflags "-s -w" -a -installsuffix cgo
darwin:
	GOOS=darwin go build -o license-check-darwin --ldflags "-s -w" -a -installsuffix cgo
