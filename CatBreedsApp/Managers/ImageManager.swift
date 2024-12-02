//
//  ImageManager.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//


import SwiftUI
import Combine

class ImageManager: ImageManagerProtocol {
    static let shared = ImageManager()
    private let cache = NSCache<NSString, UIImage>()
    private let session = URLSession.shared
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    func loadImage(for breedId: String) -> AnyPublisher<UIImage, Error> {
        if let image = cache.object(forKey: breedId as NSString) {
            return Just(image)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if let image = loadImageFromDisk(for: breedId) {
            cache.setObject(image, forKey: breedId as NSString)
            return Just(image)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return CatAPI.shared.fetchImage(for: breedId)
            .flatMap { catImage -> AnyPublisher<UIImage, Error> in
                guard let url = URL(string: catImage.url) else {
                    return Fail(error: URLError(.badURL))
                        .eraseToAnyPublisher()
                }
                return self.session.dataTaskPublisher(for: url)
                    .tryMap { data, response -> UIImage in
                        if let image = UIImage(data: data) {
                            self.cache.setObject(image, forKey: breedId as NSString)
                            self.saveImageToDisk(image: image, for: breedId)
                            return image
                        } else {
                            throw URLError(.cannotDecodeContentData)
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func imagePath(for breedId: String) -> URL {
        return cacheDirectory.appendingPathComponent("\(breedId).png")
    }
    
    private func saveImageToDisk(image: UIImage, for breedId: String) {
        let url = imagePath(for: breedId)
        if let data = image.pngData() {
            try? data.write(to: url)
        }
    }
    
    private func loadImageFromDisk(for breedId: String) -> UIImage? {
        let url = imagePath(for: breedId)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
}

