//
//  Extensions.swift
//  CountryFinder
//
//  Created by Vladyslav on 3/12/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit

enum AppStoryboard: String {
    case Main
    case Country
    case Support
}

extension AppStoryboard {
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
    
    func viewController<T:UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)";
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
