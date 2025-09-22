//
//  CartViewModel.swift
//  todo
//
//  Created by as on 22/9/25.
//

import Foundation

final class CartViewModel {
    
    static let cartUpdatedNotification = Notification.Name("CartUpdated")
    
    private(set) var cartItems: [CartItemModel] = []
    private(set) var totalPrice: Double = 0.0

    private let cartRepository: CartRepositoryProtocol

    init(cartRepository: CartRepositoryProtocol = CartRepository()) {
        self.cartRepository = cartRepository
    }

    func loadCart(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            self.cartItems = try cartRepository.fetchCartItems()
            recalculateTotal()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    func increaseQuantity(for item: CartItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        updateQuantity(item: item, newQuantity: item.quantity + 1, completion: completion)
    }

    func addItem(id: Int64, name: String, price: Double, quantity: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try cartRepository.addItem(id: id, name: name, price: price, quantity: quantity)
            loadCart(completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    func decreaseQuantity(for item: CartItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let newQty = item.quantity - 1
        updateQuantity(item: item, newQuantity: newQty, completion: completion)
    }

    func removeItem(_ item: CartItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try cartRepository.removeItem(id: item.id)
            loadCart(completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    private func updateQuantity(item: CartItemModel, newQuantity: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try cartRepository.updateQuantity(for: item.id, quantity: newQuantity)
            loadCart(completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    private func recalculateTotal() {
        totalPrice = cartItems.reduce(0.0) { $0 + ($1.price * Double($1.quantity)) }
    }

    func clearCart(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try cartRepository.clearCart()
            loadCart(completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    func formattedTotal() -> String {
        String(format: "$%.2f", totalPrice)
    }
}
