// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "swift-validations",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
  products: [
    .library(name: "Validations", targets: ["Validations"])
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "1.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-custom-dump.git", from: "1.0.0"),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "Validations",
      dependencies: [
        .product(name: "CasePaths", package: "swift-case-paths"),
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
      ]
    ),
    .testTarget(
      name: "ValidationTests",
      dependencies: [
        "Validations",
        .product(name: "CustomDump", package: "swift-custom-dump"),
      ]
    ),
  ]
)
