// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-validation-builder",
  platforms: [.macOS(.v10_15)],
  products: [
    .library(name: "Validations", targets: ["Validations"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "0.4.0"),
  ],
  targets: [
    .target(
      name: "Validations",
      dependencies: [
        .product(name: "CasePaths", package: "swift-case-paths"),
      ]
    ),
    .testTarget(
      name: "ValidationTests",
      dependencies: ["Validations"]
    ),
  ]
)
