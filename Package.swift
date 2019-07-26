// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "LocalizableStringsParser",
    products: [
        .executable(
            name: "lsp",
            targets: ["lsp"]),
        .library(
            name: "LocalizableStringsParser",
            targets: ["LocalizableStringsParser"])
    ],
    dependencies: [
        .package(url: "https://github.com/flintbox/Bouncer", from: "0.1.3")
    ],
    targets: [
        .target(
            name: "lsp",
            dependencies: ["LocalizableStringsParser", "Bouncer"]),
        .target(
            name: "LocalizableStringsParser",
            dependencies: [])
    ]
)
