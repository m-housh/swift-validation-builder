PLATFORM_IOS = iOS Simulator,name=iPhone 14 Pro
PLATFORM_MACOS = macOS
PLATFORM_MAC_CATALYST = macOS,variant=Mac Catalyst
PLATFORM_TVOS = tvOS Simulator,name=Apple TV
PLATFORM_WATCHOS = watchOS Simulator,name=Apple Watch Series 7 (45mm)
CONFIG := debug

default: test-swift

test-linux:
	@docker run --rm \
		--volume "${PWD}:${PWD}" \
		--workdir "${PWD}" \
		swift:5.7-focal \
		swift test
		
test-linux-m1:
	@docker run --rm \
		--volume "${PWD}:${PWD}" \
		--workdir "${PWD}" \
		--platform "linux/arm64" \
		swift:5.7-focal \
		swift test

test-swift:
	@swift test
	
test-library:
	for platform in "$(PLATFORM_IOS)"  "$(PLATFORM_MACOS)" "$(PLATFORM_MAC_CATALYST)" "${PLATFORM_TVOS}" "${PLATFORM_WATCHOS}"; do \
		xcodebuild test \
			-configuration $(CONFIG) \
			-workspace .swiftpm/xcode/package.xcworkspace \
			-scheme swift-validation-builder \
			-destination platform="$$platform" || exit 1; \
	done;

test-all: test-swift test-linux
	CONFIG=debug test-library
	CONFIG=release test-library

format:
	@swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		./Package.swift \
		./Sources

build-documentation:
	@swift package \
		--allow-writing-to-directory ./docs \
		generate-documentation \
		--target Validations \
		--disable-indexing \
		--transform-for-static-hosting \
		--hosting-base-path swift-validation-builder \
		--output-path ./docs

preview-documentation:
	@swift package \
		--disable-sandbox \
		preview-documentation \
		--target Validations

.PHONY: format build-documentation preview-documentation
