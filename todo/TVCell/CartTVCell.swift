//
//  CartTVCell.swift
//  todo
//
//  Created by as on 22/9/25.
//

import UIKit


final class CartCell: UITableViewCell {
    static let reuseIdentifier = "CartCell"

    // UI
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let quantityLabel = UILabel()
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private let removeButton = UIButton(type: .system)

    // Callbacks
    var onIncrease: (() -> Void)?
    var onDecrease: (() -> Void)?
    var onRemove: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        quantityLabel.font = .systemFont(ofSize: 14, weight: .regular)

        minusButton.setTitle("−", for: .normal)
        plusButton.setTitle("+", for: .normal)
        removeButton.setTitle("Remove", for: .normal)
        removeButton.setTitleColor(.systemRed, for: .normal)

        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)

        let qtyStack = UIStackView(arrangedSubviews: [minusButton, quantityLabel, plusButton])
        qtyStack.axis = .horizontal
        qtyStack.spacing = 4
        qtyStack.alignment = .center

        let mainStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel, qtyStack, removeButton])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with item: CartItemModel) {
        nameLabel.text = item.name
        priceLabel.text = String(format: "$%.2f × %d", item.price, item.quantity)
        quantityLabel.text = "\(item.quantity)"
    }

    @objc private func didTapMinus() {
        onDecrease?()
    }

    @objc private func didTapPlus() {
        onIncrease?()
    }

    @objc private func didTapRemove() {
        onRemove?()
    }
}

