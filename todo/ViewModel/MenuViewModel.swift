//
//  MenuViewModel.swift
//  todo
//
//  Created by as on 22/9/25.
//

import Foundation


final class MenuViewModel {
    
    private(set) var menuItems: [MenuItem] = []
    
    private let menuRepository: MenuRepository
    private let cartRepository: CartRepositoryProtocol
    
    init(menuRepository: MenuRepository = MenuRepository(),
         cartRepository: CartRepositoryProtocol = CartRepository()) {
        self.menuRepository = menuRepository
        self.cartRepository = cartRepository
        
    }
    
    func currentQuantity(for item: MenuItem) -> Int64? {
        do {
            let cartItems = try cartRepository.fetchCartItems()
            return cartItems.first(where: { $0.id == Int64(item.id) })?.quantity
        } catch {
            return nil
        }
    }

    func loadMenu(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            self.menuItems = try menuRepository.loadMenu()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func addToCart(item: MenuItem, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try cartRepository.addItem(id: Int64(item.id),
                                       name: item.name,
                                       price: item.price,
                                       quantity: 1)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeItem(item: MenuItem, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try cartRepository.removeItem(id: Int64(item.id))
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func decreaseQuantity(item: MenuItem, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let cartItems = try cartRepository.fetchCartItems()
            guard let cartItem = cartItems.first(where: { $0.id == Int64(item.id) }) else {
                completion(.success(()))
                return
            }
            let newQuantity = cartItem.quantity - 1
            if newQuantity > 0 {
                try cartRepository.updateQuantity(for: Int64(item.id), quantity: newQuantity)
            } else {
                try cartRepository.removeItem(id: Int64(item.id))
            }
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
}
