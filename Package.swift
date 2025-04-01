// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWExpandableTextView",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WWExpandableTextView", targets: ["WWExpandableTextView"]),
    ],
    targets: [
        .target(name: "WWExpandableTextView", resources: [.process("Xib"), .copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
