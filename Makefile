all: linux darwin

linux:
	GOOS=linux go build -o license-check
darwin:
	GOOS=darwin go build -o license-check-darwin

