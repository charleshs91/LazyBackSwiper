# LazyBackSwiper

A library to easily implement  `sloppy swiper`, which pops a view controller with a gesture from anywhere on the screen.

## Usage
In the view controller that you want to enable sloppy swiper effect, configure it as follows:

```swift
// Keep a reference to LazyBackSwiper
var lazySwiper: LazyBackSwiper?

override func viewDidLoad() {
    super.viewDidLoad()
    ...
    
    if let navigationController = navigationController {
        lazySwiper = LazyBackSwiper(navigationController: navigationController)
        navigationController.delegate = lazySwiper
    }
}
```

## Example Project
You can find the demo project in the Example folder.
