ARG SWIFT_IMAGE="swift:5.10-focal"

FROM ${SWIFT_IMAGE}

RUN export DEBIAN_FRONTEND=nointeractive DEBCONF_NOINTERACTIVE_SEEN=true \
  && apt-get -q update \
  && apt-get -q dist-upgrade -y \
  && apt-get install -y make

WORKDIR /build

COPY ./Package.* ./
RUN --mount=type=cache,target=/build/.build swift package resolve \
  $([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

COPY . .

RUN --mount=type=cache,target=/build/.build swift build

CMD = ["make", "test-swift"]
