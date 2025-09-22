//
//  CartRepository.swift
//  todo
//
//  Created by as on 22/9/25.
//

import Foundation

final class CartRepository: CartRepositoryProtocol {

    private var cartItems: [CartItemModel] {
        get { UserDefaultsHelper.loadCart() }
        set { UserDefaultsHelper.saveCart(newValue) }
    }

    func fetchCartItems() throws -> [CartItemModel] {
        return cartItems
    }

    func addItem(id: Int64, name: String, price: Double, quantity: Int64) throws {
        var items = cartItems
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].quantity += quantity
        } else {
            let newItem = CartItemModel(id: id, name: name, price: price, quantity: quantity)
            items.append(newItem)
        }
        cartItems = items
    }

    func updateQuantity(for id: Int64, quantity: Int64) throws {
        var items = cartItems
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            throw NSError(domain: "CartRepository", code: 2, userInfo: [NSLocalizedDescriptionKey: "Item not found"])
        }

        if quantity <= 0 {
            // Remove item if quantity is zero or negative
            items.remove(at: index)
        } else {
            items[index].quantity = quantity
        }
        cartItems = items
    }

    func removeItem(id: Int64) throws {
        try updateQuantity(for: id, quantity: 0)
    }

    func clearCart() throws {
        cartItems = []
    }
}
