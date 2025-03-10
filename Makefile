PLATFORM_IOS = iOS Simulator,name=iPhone 14 Pro
PLATFORM_MACOS = macOS
PLATFORM_MAC_CATALYST = macOS,variant=Mac Catalyst
PLATFORM_TVOS = tvOS Simulator,name=Apple TV
PLATFORM_WATCHOS = watchOS Simulator,name=Apple Watch Series 7 (45mm)
CONFIG := debug
SWIFT_VERSION = 5.10
DOCKER_PLATFORM := linux/arm64
DOCKER_IMAGE_NAME := "swift-validations"
DOCKER_TAG := "latest"

default: test-swift

build-docker:
	docker build -t "$(DOCKER_IMAGE_NAME):$(DOCKER_TAG)" .

test-linux: build-docker
	docker run --rm "$(DOCKER_IMAGE_NAME):$(DOCKER_TAG)" make test-swift

test-swift:
	swift test

test-library:
	for platform in "$(PLATFORM_IOS)"  "$(PLATFORM_MACOS)" "$(PLATFORM_MAC_CATALYST)" "${PLATFORM_TVOS}" "${PLATFORM_WATCHOS}"; do \
		xcodebuild test \
			-configuration $(CONFIG) \
			-skipMacroValidation \
			-workspace .swiftpm/xcode/package.xcworkspace \
			-scheme swift-validations \
			-destination platform="$$platform" || exit 1; \
	done;

test-all: test-linux
	CONFIG=debug test-library

format:
	swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		./Package.swift \
		./Sources

build-documentation:
	swift package \
		--allow-writing-to-directory ./docs \
		generate-documentation \
		--target Validations \
		--disable-indexing \
		--transform-for-static-hosting \
		--hosting-base-path swift-validations \
		--output-path ./docs

preview-documentation:
	swift package \
		--disable-sandbox \
		preview-documentation \
		--target Validations

.PHONY: format build-documentation preview-documentation
