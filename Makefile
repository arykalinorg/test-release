ifdef BUILD_NUMBER
VERSION=`git describe --abbrev=0 --tags`+$(BUILD_NUMBER)
else
VERSION=`git describe --abbrev=0 --tags`
endif

ifdef RELEASE_VERSION
ifdef BUILD_NUMBER
VERSION=$(RELEASE_VERSION)+$(BUILD_NUMBER)
else
VERSION=$(RELEASE_VERSION)
endif
endif
BUILD_DIR=./
BIN_DIR=bin
build:
	rm -rf $(BIN_DIR)
	env GOOS=linux   GOARCH=amd64 go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)-$(VERSION)-linux $(BUILD_DIR)
	env GOOS=linux   GOARCH=386   go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)-$(VERSION)-linux86 $(BUILD_DIR)
	env GOOS=darwin  GOARCH=amd64 go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)-$(VERSION)-darwin $(BUILD_DIR)
	env GOOS=darwin  GOARCH=386   go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)-$(VERSION)-darwin86 $(BUILD_DIR)
	env GOOS=windows GOARCH=amd64 go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)-$(VERSION).exe $(BUILD_DIR)
	env  GOOS=windows GOARCH=386   go build $(GO_LDFLAGS) -o $(BIN_DIR)/$$(basename $$PWD)86-$(VERSION).exe $(BUILD_DIR)
	echo '```' > release.txt
	cd $(BIN_DIR); sha1sum * >> ../release.txt
	echo '```' >> release.txt

release:
	go get -u github.com/tcnksm/ghr
	echo $$RELEASE_VERSION
	ghr -prerelease -n $$RELEASE_VERSION -body="$$(cat ./release.txt)" $$RELEASE_VERSION bin/

