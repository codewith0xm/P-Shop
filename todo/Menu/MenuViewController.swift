//
//  MenuViewController.swift
//  todo
//
//  Created by as on 22/9/25.
//

import UIKit

final class MenuViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)

    private let viewModel: MenuViewModel

    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(MenuCell.self, forCellReuseIdentifier: MenuCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    
    private func bindViewModel() {
        viewModel.loadMenu { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.menuItems.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseIdentifier,
                                                      for: indexPath) as? MenuCell else {
            return UITableViewCell()
        }
        let item = viewModel.menuItems[indexPath.row]
        cell.configure(with: item)
        
        if let quantity = viewModel.currentQuantity(for: item), quantity > 0 {
            cell.setAddedState(quantity: Int(quantity))
        }

        // Add button action – adds item to cart and shows quantity controls
        cell.addButtonAction = { [weak self, weak cell] in
            self?.viewModel.addToCart(item: item) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        cell?.setAddedState(quantity: 1)

                        let toast = UIAlertController(title: nil,
                                                      message: "\(item.name) added to cart",
                                                      preferredStyle: .alert)
                        self?.present(toast, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            toast.dismiss(animated: true)
                        }
                    case .failure(let error):
                        self?.showError(error)
                    }
                }
            }
        }

        // Increase quantity – reuse addToCart (repository will increment)
        cell.onIncrease = { [weak self, weak cell] in
            self?.viewModel.addToCart(item: item) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        // Increment displayed quantity
                        let current = cell?.currentQuantity() ?? 0
                        cell?.setAddedState(quantity: current + 1)
                    case .failure(let error):
                        self?.showError(error)
                    }
                }
            }
        }

        // Decrease quantity – remove item entirely (fallback behavior)
        cell.onDecrease = { [weak self, weak cell] in
            self?.viewModel.decreaseQuantity(item: item) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        // Decrement displayed quantity or hide UI if quantity reaches zero
                        let current = cell?.currentQuantity() ?? 0
                        if current > 1 {
                            cell?.setAddedState(quantity: current - 1)
                        } else {
                            cell?.updateUIForAdded(false, quantity: 0)
                        }
                    case .failure(let error):
                        self?.showError(error)
                    }
                }
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    // No additional delegate behavior needed for now
}

