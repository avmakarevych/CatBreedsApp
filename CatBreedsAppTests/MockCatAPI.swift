//
//  MockCatAPI.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//


import Combine
@testable import CatBreedsApp
import Foundation

class MockCatAPI: CatAPIProtocol {
    var fetchBreedsResult: AnyPublisher<[Breed], Error>
    var fetchImageResult: AnyPublisher<CatImage, Error>

    init() {
        fetchBreedsResult = Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        fetchImageResult = Fail(error: URLError(.badURL))
            .eraseToAnyPublisher()
    }

    func fetchBreeds() -> AnyPublisher<[Breed], Error> {
        return fetchBreedsResult
    }

    func fetchImage(for breedId: String) -> AnyPublisher<CatImage, Error> {
        return fetchImageResult
    }
}

