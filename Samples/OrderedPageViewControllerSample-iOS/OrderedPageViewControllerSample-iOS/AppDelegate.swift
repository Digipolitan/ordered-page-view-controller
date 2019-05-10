//
//  AppDelegate.swift
//  OrderedPageViewControllerSample-iOS
//
//  Created by Benoit BRIATTE on 23/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit
import OrderedPageViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let orderedPageViewController = OrderedPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        orderedPageViewController.orderedDelegate = self
        orderedPageViewController.orderedDataSource = self
        orderedPageViewController.isInfinite = true
        let navigation = UINavigationController(rootViewController: orderedPageViewController)
        navigation.navigationBar.isTranslucent = false
        window.rootViewController = navigation
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate: OrderedPageViewControllerDelegate, OrderedPageViewControllerDataSource {

    func orderedPageViewController(_ orderedPageViewController: OrderedPageViewController, didScrollToViewControllerAt index: Int) {
        print("Scroll at \(index)")
    }

    func orderedPageViewController(_ orderedPageViewController: OrderedPageViewController, willScrollToViewControllerAt index: Int) {
        print("Will scroll at \(index)")
    }

    func orderedPageViewController(_ orderedPageViewController: OrderedPageViewController, viewControllerAt index: Int) -> UIViewController {
        return ViewController.newInstance(index: index)
    }

    func numberOfPages(in orderedPageViewController: OrderedPageViewController) -> Int {
        return 10
    }
}
