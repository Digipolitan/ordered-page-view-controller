//
//  NavigationController.swift
//  OrderedPageViewControllerSample-iOS
//
//  Created by Benoit Briatte on 30/05/2019.
//  Copyright © 2019 Digipolitan. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        return self.visibleViewController
    }

    override var childForStatusBarHidden: UIViewController? {
        return self.visibleViewController
    }

    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return self.visibleViewController
    }

    override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return self.visibleViewController
    }
}
