//
//  TabBarViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 09.07.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        tabBar.tintColor = .label
        setupVCs()
    }

    private func setupVCs() {
        viewControllers = [
            createNavController(for: FriendsViewController(), title: "Друзья", image: UIImage.init(systemName: "person.2.fill")!)
        ]
    }
    

    fileprivate func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage) -> UIViewController {

        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }

}
