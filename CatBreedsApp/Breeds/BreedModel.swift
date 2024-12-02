//
//  CatModels.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//

import Foundation

struct Breed: Codable, Identifiable {
    let id: String
    let name: String
    let temperament: String?
    let origin: String?
    let description: String?
    let wikipedia_url: String?

    init(
        id: String,
        name: String,
        temperament: String? = nil,
        origin: String? = nil,
        description: String? = nil,
        wikipedia_url: String? = nil
    ) {
        self.id = id
        self.name = name
        self.temperament = temperament
        self.origin = origin
        self.description = description
        self.wikipedia_url = wikipedia_url
    }
}
struct CatImage: Codable, Identifiable {
    let id: String
    let url: String
    let breeds: [Breed]?
}
