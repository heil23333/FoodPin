//
//  NavigationController.swift
//  FoodPin
//
//  Created by  He on 2025/12/2.
//

import UIKit

class NavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

}
