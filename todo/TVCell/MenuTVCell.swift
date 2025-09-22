//
//  MenuTVCell.swift
//  todo
//
//  Created by as on 22/9/25.
//

import UIKit

final class MenuCell: UITableViewCell {
    static let reuseIdentifier = "MenuCell"

    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let quantityLabel = UILabel()
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private let addButton = UIButton(type: .system)
    private lazy var itemImg : UIImageView = UIImageView()
    

    var addButtonAction: (() -> Void)?
    var onIncrease: (() -> Void)?
    var onDecrease: (() -> Void)?

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
        priceLabel.textColor = .secondaryLabel
        

        quantityLabel.font = .systemFont(ofSize: 14, weight: .regular)
        quantityLabel.textAlignment = .center

        minusButton.setTitle("−", for: .normal)
        plusButton.setTitle("+", for: .normal)

        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)

        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)

        let qtyStack = UIStackView(arrangedSubviews: [minusButton, quantityLabel, plusButton])
        qtyStack.axis = .horizontal
        qtyStack.spacing = 4
        qtyStack.alignment = .center

        let mainStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel, qtyStack, addButton])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        itemImg.translatesAutoresizingMaskIntoConstraints = false
        itemImg.contentMode = .scaleAspectFit

        contentView.addSubview(itemImg)
        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            // Image constraints
            itemImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImg.widthAnchor.constraint(equalToConstant: 25),
            itemImg.heightAnchor.constraint(equalToConstant: 25),

            // Main stack to the right of image
            mainStack.leadingAnchor.constraint(equalTo: itemImg.trailingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        updateUIForAdded(false, quantity: 0)
    }


    func updateUIForAdded(_ added: Bool, quantity: Int) {
        addButton.isHidden = added
        quantityLabel.isHidden = !added
        plusButton.isHidden = !added
        minusButton.isHidden = !added
        quantityLabel.text = "\(quantity)"
    }

    func setAddedState(quantity: Int) {
        updateUIForAdded(true, quantity: quantity)
    }

    func currentQuantity() -> Int {
        return Int(quantityLabel.text ?? "0") ?? 0
    }

    func configure(with item: MenuItem) {
        nameLabel.text = item.name
        itemImg.image = UIImage(named: item.image)
        priceLabel.text = String(format: "$%.2f", item.price)
        updateUIForAdded(false, quantity: 0)
    }

    @objc private func didTapAdd() {
        addButtonAction?()
    }

    @objc private func didTapMinus() {
        onDecrease?()
    }

    @objc private func didTapPlus() {
        onIncrease?()
    }
}
