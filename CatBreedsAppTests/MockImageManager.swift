//
//  MockImageManager.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//

import UIKit
import Combine
@testable import CatBreedsApp

class MockImageManager: ImageManagerProtocol {
    var loadImageResult: AnyPublisher<UIImage, Error>

    init() {
        loadImageResult = Fail(error: URLError(.badURL))
            .eraseToAnyPublisher()
    }

    func loadImage(for breedId: String) -> AnyPublisher<UIImage, Error> {
        return loadImageResult
    }
}
