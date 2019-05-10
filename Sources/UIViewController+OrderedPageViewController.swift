//
//  UIViewController+OrderedPageViewController.swift
//  OrderedPageViewController
//
//  Created by Benoit BRIATTE on 28/07/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit

public extension UIViewController {

    var orderedPageViewController: OrderedPageViewController? {
        var current = self
        while let parent = current.parent {
            if let side = parent as? OrderedPageViewController {
                return side
            }
            current = parent
        }
        return nil
    }
}
