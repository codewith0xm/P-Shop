//
//  CartRepositoryProtocol.swift
//  todo
//
//  Created by as on 22/9/25.
//

import Foundation

protocol CartRepositoryProtocol {
    func fetchCartItems() throws -> [CartItemModel]
    func addItem(id: Int64, name: String, price: Double, quantity: Int64) throws
    func updateQuantity(for id: Int64, quantity: Int64) throws
    func removeItem(id: Int64) throws
    func clearCart() throws
}
