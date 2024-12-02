//
//  ImageManagerProtocol.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//


import UIKit
import Combine

protocol ImageManagerProtocol {
    func loadImage(for breedId: String) -> AnyPublisher<UIImage, Error>
}
