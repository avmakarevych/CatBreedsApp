//
//  CatAPI.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//

import Foundation
import Combine

class CatAPI: CatAPIProtocol {
    static let shared = CatAPI()
    private let session = URLSession.shared
    
    func fetchBreeds() -> AnyPublisher<[Breed], Error> {
        let url = URL(string: "https://api.thecatapi.com/v1/breeds")!
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Breed].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchImage(for breedId: String) -> AnyPublisher<CatImage, Error> {
        let urlString = "https://api.thecatapi.com/v1/images/search"
        let url = URL(string: "\(urlString)?breed_ids=\(breedId)&limit=1")!
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [CatImage].self, decoder: JSONDecoder())
            .compactMap { $0.first }
            .eraseToAnyPublisher()
    }
}
