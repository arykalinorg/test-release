ifdef BUILD_NUMBER
VERSION=`git describe --abbrev=0 --tags`+$(BUILD_NUMBER)
else
VERSION=`git describe --abbrev=0 --tags`
endif

ifdef RELEASE_VERSION
FILE_VERSION=$(RELEASE_VERSION)
else
FILE_VERSION=$(VERSION)
endif
BUILD_DIR=./
BIN_DIR=bin
build:
	rm -rf $(BIN_DIR)
	env GOOS=linux   GOARCH=amd64 go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)-$(FILE_VERSION)-linux $(BUILD_DIR)
	env GOOS=linux   GOARCH=386   go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)-$(FILE_VERSION)-linux86 $(BUILD_DIR)
	env GOOS=darwin  GOARCH=amd64 go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)-$(FILE_VERSION)-darwin $(BUILD_DIR)
	env GOOS=darwin  GOARCH=386   go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)-$(FILE_VERSION)-darwin86 $(BUILD_DIR)
	env GOOS=windows GOARCH=amd64 go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)-$(FILE_VERSION).exe $(BUILD_DIR)
	env  GOOS=windows GOARCH=386   go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)86-$(FILE_VERSION).exe $(BUILD_DIR)
	echo '```' > release.txt
	cd $(BIN_DIR); sha1sum * > hashsums.sha1
	echo '```' >> release.txt

release:
	echo $$RELEASE_VERSION
	ghr -prerelease -n $$RELEASE_VERSION -body="$$(cat ./release.txt)" $$RELEASE_VERSION bin/

