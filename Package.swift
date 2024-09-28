// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ConvertViewToPDFData-package",
    products: [
        .library(
            name: "ConvertViewToPDFData-module",
            targets: ["ConvertViewToPDFData-module"]
        ),
    ],
    targets: [
        .target(
            name: "ConvertViewToPDFData-module"
        ),
        .testTarget(
            name: "ConvertViewToPDFData-tests",
            dependencies: ["ConvertViewToPDFData-module"]
        ),
    ]
)
