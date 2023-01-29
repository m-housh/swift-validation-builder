
test-linux:
	@docker run --rm -v "${PWD}:${PWD}" -w "${PWD}" swift:5.7-focal swift test

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
