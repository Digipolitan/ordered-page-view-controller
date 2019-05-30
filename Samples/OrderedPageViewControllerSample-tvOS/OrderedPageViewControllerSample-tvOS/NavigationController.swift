//
//  NavigationController.swift
//  OrderedPageViewControllerSample-tvOS
//
//  Created by Benoit Briatte on 30/05/2019.
//  Copyright © 2019 Digipolitan. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var childViewControllerForUserInterfaceStyle: UIViewController? {
        return self.visibleViewController
    }
}
