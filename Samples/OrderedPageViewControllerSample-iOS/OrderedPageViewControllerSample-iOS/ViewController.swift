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
        self.titleLabel.text = "ViewController index \(self.index!)"
    }

    @IBAction public func touchItem2() {
        self.orderedPageViewController?.scroll(toViewControllerAt: 2, animated: true)
    }

    @IBAction public func touchItem8() {
        self.orderedPageViewController?.scroll(toViewControllerAt: 8, animated: true)
    }
}
