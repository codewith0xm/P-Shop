//
//  MenuCoordinator.swift
//  todo
//
//  Created by as on 22/9/25.
//

import UIKit

final class MenuCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MenuViewModel()
        let vc = MenuViewController(viewModel: viewModel)
        vc.title = "Menu"
        navigationController.pushViewController(vc, animated: false)
    }
}
