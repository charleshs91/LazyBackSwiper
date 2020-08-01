// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "LazyBackSwiper",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(name: "LazyBackSwiper", targets: ["LazyBackSwiper"]),
    ],
    targets: [
        .target(name: "LazyBackSwiper", dependencies: []),
        .testTarget(name: "LazyBackSwiperTests", dependencies: ["LazyBackSwiper"]),
    ]
)
