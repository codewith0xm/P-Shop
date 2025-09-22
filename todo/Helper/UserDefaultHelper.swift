//
//  UserDefaultHelper.swift
//  todo
//
//  Created by as on 22/9/25.
//

import Foundation

struct UserDefaultsHelper {
    private static let cartKey = "cartItems"

    static func saveCart(_ items: [CartItemModel]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(items) else { return }
        UserDefaults.standard.set(data, forKey: cartKey)
    }

    static func loadCart() -> [CartItemModel] {
        guard let data = UserDefaults.standard.data(forKey: cartKey) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([CartItemModel].self, from: data)) ?? []
    }
}
