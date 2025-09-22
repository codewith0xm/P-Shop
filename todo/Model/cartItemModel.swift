//
//  cartItemModel.swift
//  todo
//
//  Created by as on 22/9/25.
//

import Foundation

struct CartItemModel: Codable {
    let id: Int64
    let name: String
    let price: Double
    var quantity: Int64
}
