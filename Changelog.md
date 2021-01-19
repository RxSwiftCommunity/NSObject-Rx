Changelog
=========

Current master
--------------

- Nothing yet!

5.2.0
-----

- Adds support for RxSwift 6 - [@jinsu3758](https://github.com/jinsu3758)
- Increases minimum deployment target to iOS 9.0 - [@ashfurrow](https://github.com/ashfurrow)

5.1.1
-----

- FIxes problem with an inability to access `HasDisposeBag` when using SPM. See [#82](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/82) - [@mtfum](https://github.com/mtfum)

5.1.0
-----

- Update RxSwift

5.0.3
-----

**Note**: This is an SPM-only release. It's functionally identical to 5.0.2 for CocoaPods and Carthage users.

- Adds support for SPM. See [#79](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/79) - [@pomozoff](https://github.com/pomozoff)

5.0.2
-----
- Add the public modifier access to the disposeBag property. See [#74](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/74) - [@Vkt0r](https://github.com/Vkt0r)

5.0.1
-----
- Update to Swift 5.0 to build in CI

5.0.0
-----
- Update to Swift 5.0 and Xcode 10.2 See [#59](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/67) - [@fassko](https://github.com/fassko)
- Build in Circle CI 2.0 and remove Pods from repo. See [#59](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/68) - [@fassko](https://github.com/fassko)
- Increase watchOS minimum version. See [#59](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/68) - [@fassko](https://github.com/fassko)

4.4.1
-----
- Specify Swift 4.2 in podspec and .swift-version See [#59](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/59) - [@fassko](https://github.com/fassko)

4.4.0
-----
- Swift 4.2 and Xcode 10 support See [#58](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/58) - [@fassko](https://github.com/fassko)

4.3.0
-----

- Update the dependencies in the Cartfile & Podfile. See [#57](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/57) - @Vkt0r
- Replace the deprecated `addDisposableTo(_:)` in favor of `disposed(by:)` in the DemoTest. See [#57](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/57) - @Vkt0r

4.2.0
-----

- Re-adds HasDisposeBag protocol. See [#49](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/49) - [@twittemb](https://github.com/twittemb)
- Fixes for Carthage. See [#56](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/56) - [@Gurpartap](https://github.com/Gurpartap)

4.1.0
-----

- Upgrades to RxSwift 4.0. See [#50](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/50) - [@joanii](https://github.com/joanii)

4.0.0
-----

- Fixes a warning when used in application extensions. See [#45](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/45) - [@mono0926](https://github.com/mono0926)
- Removes suport for using dispose bags on reference types. See [#47](https://github.com/RxSwiftCommunity/NSObject-Rx/issues/47) - [@grinder81](https://github.com/grinder81)

3.0.1
-----

- Fixes Carthage install problems wiht 3.0.0 release. See [#44](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/44) - [@mono0926](https://github.com/mono0926)

3.0.0
-----

- Move to a new protocol-based approach, allowing non-reference types to use the library 🎉 See [#41](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/41) - [@twittemb](https://github.com/twittemb)
- Removes `rx_disposeBag` in favour of `rx.disposeBag`.

2.3.0
-----
- Make rx.disposeBag read/write ([#40](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/40)) - [@freak4pc](https://github.com/freak4pc)

- Change macOS minimum deployment target to 10.10 to support RxSwift 3.0 ([#39](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/29)) - [@freak4pc](https://github.com/freak4pc)

- Allow usage of rx.disposeBag alongside rx_disposeBag ([#29](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/29)) - [@freak4pc](https://github.com/freak4pc)

- Change xcodeproj name for Carthage ([#35](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/35)) - [@toshi0383](https://github.com/toshi0383)

2.0.0
-----

- Support Swift 3

1.2.2
-----

- [Nothing yet](https://github.com/RxSwiftCommunity/NSObject-Rx/compare)!

1.2.1
-----

- Removes constraint on RxSwift 2.0.0.

1.2.0
-----

- Updates to RxSwift 2.0 🎉

1.1.0
-----

- Prevents race condition in getter ([#2](https://github.com/RxSwiftCommunity/NSObject-Rx/pull/2)) – [@lipka](https://github.com/lipka)

1.0.0
-----

- Initial release.
