//
//  MainTabBarController.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstNC = UINavigationController(rootViewController: RegionsViewController.instantiate(fromAppStoryboard: .Country))
        firstNC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        
        let secondNC = UINavigationController(rootViewController: SearchViewController.instantiate(fromAppStoryboard: .Support))
        secondNC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let thirdNC = UINavigationController(rootViewController: DatabaseViewController.instantiate(fromAppStoryboard: .Support))
        thirdNC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        
        viewControllers = [firstNC, secondNC, thirdNC]
    }
}
