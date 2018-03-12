all: linux darwin arm

linux:
	GOOS=linux go build -o license-check
arm:
	GOOS=linux GOARCH=arm GOARM=6 go build -o license-check-armhf
darwin:
	GOOS=darwin go build -o license-check-darwin

