OrderedPageViewController
=================================

[![Build Status](https://travis-ci.org/Digipolitan/ordered-page-view-controller-swift.svg?branch=master)](https://travis-ci.org/Digipolitan/ordered-page-view-controller-swift)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/OrderedPageViewController.svg)](https://img.shields.io/cocoapods/v/OrderedPageViewController.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/OrderedPageViewController.svg?style=flat)](http://cocoadocs.org/docsets/OrderedPageViewController)
[![Twitter](https://img.shields.io/badge/twitter-@Digipolitan-blue.svg?style=flat)](http://twitter.com/Digipolitan)

OrderedPageViewController is a UIPageViewContoller using delegate & dataSource to provide UIViewController with indexes

## Installation

### CocoaPods

To install OrderedPageViewController with CocoaPods, add the following lines to your `Podfile`.

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0' # or platform :osx, '10.10' if your target is OS X.
use_frameworks!

pod 'OrderedPageViewController'
```

## The Basics

First you must create a OrderedPageViewController and register delegate and dateSource, after that add the controller to your interface

```swift
let orderedPageViewController = OrderedPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
orderedPageViewController.orderedDelegate = self
orderedPageViewController.orderedDataSource = self
orderedPageViewController.isInfinite = true
let navigation = UINavigationController(rootViewController: orderedPageViewController)
navigation.navigationBar.isTranslucent = false
window.rootViewController = navigation
```

## Implements OrderedPageViewControllerDataSource

```swift
func orderedPageViewController(_ orderedPageViewController: OrderedPageViewController, viewControllerAt index: Int) -> UIViewController {
  return // INSTANCIATE CONTROLLER HERE
}

func numberOfPages(in orderedPageViewController: OrderedPageViewController) -> Int {
  return 10
}
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details!

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report
unacceptable behavior to [contact@digipolitan.com](mailto:contact@digipolitan.com).

## License

OrderedPageViewController is licensed under the [BSD 3-Clause license](LICENSE).
