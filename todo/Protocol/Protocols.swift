//
//  Protocols.swift
//  todo
//
//  Created by as on 22/9/25.
//

import UIKit

// MARK: - Coordinator Protocol
protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
