//
//  TabBarController.swift
//  Searching-Github-Repositories-App
//
//  Created by Apple on 2022/11/18.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBarController()
    }
}

//MARK: - Set up
extension TabBarController {
    func setUpTabBarController() {
        self.tabBar.tintColor = Constants.Color.mainColor
        setChildrenViewControllers()
    }
    func setChildrenViewControllers() {
        let searchVC = SearchViewController()
        let profileVC = ProfileViewController()
        
        searchVC.title = Constants.SearchViewController.tabbarTitle
        profileVC.title = Constants.ProfileViewController.tabbarTitle
        
        searchVC.tabBarItem.image = Constants.Image.magnifyingglass
        profileVC.tabBarItem.image = Constants.Image.person
        
        setViewControllers([searchVC, profileVC], animated: false)
    }
}
