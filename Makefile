ifdef BUILD_NUMBER
VERSION=`git describe --abbrev=0 --tags`+$(BUILD_NUMBER)
else
VERSION=`git describe --abbrev=0 --tags`
endif

BUILD_DIR=./
build:
	env GOOS=linux   GOARCH=amd64 go build $(GO_LDFLAGS) -o bin/$$(basename $$PWD)-$(VERSION)-linux $(BUILD_DIR)
	env GOOS=linux   GOARCH=386   go build $(GO_LDFLAGS) -o bin/$$(basename $$PWD)-$(VERSION)-linux86 $(BUILD_DIR)
	env GOOS=darwin  GOARCH=amd64 go build $(GO_LDFLAGS) -o bin/$$(basename $$PWD)-$(VERSION)-darwin $(BUILD_DIR)
	env GOOS=darwin  GOARCH=386   go build $(GO_LDFLAGS) -o bin/$$(basename $$PWD)-$(VERSION)-darwin86 $(BUILD_DIR)
	env GOOS=windows GOARCH=amd64 go build $(GO_LDFLAGS) -o bin/$$(basename $$PWD)-$(VERSION).exe $(BUILD_DIR)
	env  GOOS=windows GOARCH=386   go build $(GO_LDFLAGS) -o bin/$$(basename $$PWD)86-$(VERSION).exe $(BUILD_DIR)
	sha256sum bin/* > release.txt