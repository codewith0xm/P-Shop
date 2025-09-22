//
//  MenuRepository.swift
//  todo
//
//  Created by as on 22/9/25.
//

import Foundation

final class MenuRepository {
    private let jsonFileName = "menu"
    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func loadMenu() throws -> [MenuItem] {
        guard let url = bundle.url(forResource: jsonFileName, withExtension: "json") else {
            throw NSError(domain: "MenuRepository",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Menu JSON file not found"])
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let menuResponse = try decoder.decode(MenuResponse.self, from: data)
        return menuResponse.menu
    }
}

// MARK: - Decodable structs matching the JSON structure
private struct MenuResponse: Decodable {
    let menu: [MenuItem]
}
