// swift-tools-version:5.4

import PackageDescription

let name = "FirebaseProxy"

let package = Package(
    name: name,
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: name,
            targets: [name,
                      "FBLPromises",
                      "FirebaseABTesting",
                      "FirebaseCore",
                      "FirebaseCoreInternal",
                      "FirebaseInstallations",
                      "FirebaseMessaging",
                      "FirebaseRemoteConfig",
                      "FirebaseRemoteConfigInterop",
                      "FirebaseSharedSwift",
                      "GoogleDataTransport",
                      "GoogleUtilities",
                      "nanopb",
                     ]),
    ],
    targets: [
        .target(
            name: name,
            dependencies: [],
            linkerSettings: [
                .unsafeFlags(["-ObjC"])
            ]
        ),
        .binaryTarget(
            name: "FirebaseABTesting",
            path: "FirebaseABTesting/FirebaseABTesting.xcframework"
        ),
        .binaryTarget(
            name: "nanopb",
            path: "FirebaseRemoteConfig/nanopb.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseRemoteConfig",
            path: "FirebaseRemoteConfig/FirebaseRemoteConfig.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseInstallations",
            path: "FirebaseRemoteConfig/FirebaseInstallations.xcframework"
        ),
        .binaryTarget(
            name: "FBLPromises",
            path: "FirebaseRemoteConfig/FBLPromises.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseCore",
            path: "FirebaseRemoteConfig/FirebaseCore.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseCoreInternal",
            path: "FirebaseRemoteConfig/FirebaseCoreInternal.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseSharedSwift",
            path: "FirebaseRemoteConfig/FirebaseSharedSwift.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseRemoteConfigInterop",
            path: "FirebaseRemoteConfig/FirebaseRemoteConfigInterop.xcframework"
        ),
        .binaryTarget(
            name: "GoogleUtilities",
            path: "FirebaseRemoteConfig/GoogleUtilities.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseMessaging",
            path: "FirebaseMessaging/FirebaseMessaging.xcframework"
        ),
        .binaryTarget(
            name: "GoogleDataTransport",
            path: "FirebaseMessaging/GoogleDataTransport.xcframework"
        )
    ]
)

