//
//  CartViewController.swift
//  todo
//
//  Created by as on 22/9/25.
//

import UIKit

final class CartViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let totalLabel = UILabel()
    private let checkoutButton = UIButton(type: .system)

    private let viewModel: CartViewModel

    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindViewModel()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        // Footer stack
        let footerStack = UIStackView(arrangedSubviews: [totalLabel, checkoutButton])
        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.spacing = 16
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerStack)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            footerStack.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            footerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            footerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            footerStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])

        totalLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        checkoutButton.setTitle("Checkout", for: .normal)
        checkoutButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        checkoutButton.isEnabled = false
        checkoutButton.addTarget(self, action: #selector(didTapCheckout), for: .touchUpInside)
    }

    private func bindViewModel() {
        viewModel.loadCart { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.tableView.reloadData()
                    self?.updateFooter()
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }

    private func updateFooter() {
        totalLabel.text = "TOTAL: \(viewModel.formattedTotal())"
        // Minimum order value is defined in the JSON (12.5)
        checkoutButton.isEnabled = viewModel.totalPrice >= 12.5
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func didTapCheckout() {
        let alert = UIAlertController(title: "Checkout",
                                      message: "Proceed with checkout of total \(viewModel.formattedTotal())?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { _ in
            self.viewModel.clearCart { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        self.bindViewModel()
                    case .failure(let error):
                        self.showError(error)
                    }
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cartItems.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseIdentifier,
                                                      for: indexPath) as? CartCell else {
            return UITableViewCell()
        }
        let item = viewModel.cartItems[indexPath.row]
        cell.configure(with: item)
        cell.onIncrease = { [weak self] in
            self?.viewModel.increaseQuantity(for: item) { _ in self?.bindViewModel() }
        }
        cell.onDecrease = { [weak self] in
            self?.viewModel.decreaseQuantity(for: item) { _ in self?.bindViewModel() }
        }
        cell.onRemove = { [weak self] in
            self?.viewModel.removeItem(item) { _ in self?.bindViewModel() }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    // No extra delegate methods needed now
}

