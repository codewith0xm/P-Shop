//
//  CartCoordinator.swift
//  todo
//
//  Created by as on 22/9/25.
//

import UIKit

final class CartCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = CartViewModel()
        let vc = CartViewController(viewModel: viewModel)
        vc.title = "Cart"
        navigationController.pushViewController(vc, animated: false)
    }
}

