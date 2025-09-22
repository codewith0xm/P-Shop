//
//  RootCoordinator.swift
//  todo
//
//  Created by as on 22/9/25.
//

import UIKit

final class RootCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        
        let tabBarController = UITabBarController()

        let menuNav = UINavigationController()
        let menuCoordinator = MenuCoordinator(navigationController: menuNav)
        menuCoordinator.start()
        menuNav.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(systemName: "list.dash"), tag: 0)

        let cartNav = UINavigationController()
        let cartCoordinator = CartCoordinator(navigationController: cartNav)
        cartCoordinator.start()
        cartNav.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 1)


        tabBarController.viewControllers = [menuNav, cartNav]

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
