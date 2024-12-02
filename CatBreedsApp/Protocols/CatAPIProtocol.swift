//
//  CatAPIProtocol.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//


import Foundation
import Combine

protocol CatAPIProtocol {
    func fetchBreeds() -> AnyPublisher<[Breed], Error>
    func fetchImage(for breedId: String) -> AnyPublisher<CatImage, Error>
}