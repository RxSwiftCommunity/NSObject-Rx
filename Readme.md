[![Build Status](https://travis-ci.org/ashfurrow/NSObject-Rx.svg)](https://travis-ci.org/ashfurrow/NSObject-Rx)

NSObject+Rx
===========

If you're using [RxSwift](https://github.com/ReactiveX/RxSwift), you've probably encountered the following code more than a few times.

```swift
class MyObject: Whatever {
	let disposeBag = DisposeBag()

	...
}
```

You're actually not the only one to have written this line many, many times.

![Search screenshot showing many, many results.](assets/screenshot.png)

Instead of adding a new property to every object using RxSwift, use this library to add it for you, to any subclass of `NSObject`. 

```swift
thing
  .bindTo(otherThing)
  .addDisposableTo(rx_disposeBag())
```

Sweet.

License
-------

MIT obvs.

![Tim Cook dancing to the sound of a permissive license.](http://i.imgur.com/mONiWzj.gif)
