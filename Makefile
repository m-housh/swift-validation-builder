
test-linux:
	@docker run --rm \
		--volume "${PWD}:${PWD}" \
		--workdir "${PWD}" \
		swift:5.7-focal \
		swift test

test-swift:
	@swift test

test-all: test-swift test-linux

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
