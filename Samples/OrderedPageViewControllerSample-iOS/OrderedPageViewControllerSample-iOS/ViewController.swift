//
//  ViewController.swift
//  OrderedPageViewControllerSample-iOS
//
//  Created by Benoit BRIATTE on 23/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit
import OrderedPageViewController

class ViewController: UIViewController {

    var index: Int!

    public static func newInstance(index: Int) -> ViewController {
        let viewController = ViewController()
        viewController.index = index
        return viewController
    }

    @IBOutlet var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "index \(self.index!)"
        self.titleLabel.text = "ViewController index \(self.index!)"
        self.navigationItem.rightBarButtonItem = .init(title: "Push other orientation", style: .done, target: self, action: #selector(pushOtherOrientation))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.index % 3 == 0, animated: animated)
    }

    @IBAction public func touchItem2() {
        self.orderedPageViewController?.scroll(toViewControllerAt: 2, animated: true)
    }

    @IBAction public func touchItem8() {
        self.orderedPageViewController?.scroll(toViewControllerAt: 8, animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return self.index % 2 == 0
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return self.index % 2 == 1
    }

    @objc func pushOtherOrientation() {
        let orientation: UIPageViewController.NavigationOrientation = self.orderedPageViewController?.navigationOrientation == .horizontal ? .vertical : .horizontal
        let orderedPageViewController = OrderedPageViewController(transitionStyle: .scroll, navigationOrientation: orientation)
        orderedPageViewController.orderedDelegate = self.orderedPageViewController?.orderedDelegate
        orderedPageViewController.orderedDataSource = self.orderedPageViewController?.orderedDataSource
        orderedPageViewController.scroll(toViewControllerAt: self.index, animated: false)
        self.navigationController?.pushViewController(orderedPageViewController, animated: true)
    }
}
