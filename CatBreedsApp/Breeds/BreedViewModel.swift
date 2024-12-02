//
//  BreedViewModel.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//

import Foundation
import Combine
import UIKit

class BreedViewModel: ObservableObject {
    @Published var breeds: [Breed] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let api: CatAPIProtocol
    
    init(api: CatAPIProtocol = CatAPI.shared) {
        self.api = api
        fetchBreeds()
    }
    
    func fetchBreeds() {
        isLoading = true
        errorMessage = nil
        api.fetchBreeds()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.breeds = []
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] breeds in
                self?.breeds = breeds
            })
            .store(in: &cancellables)
    }
    
    var filteredBreeds: [Breed] {
        if searchText.isEmpty {
            return breeds
        } else {
            return breeds.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}



class BreedCellViewModel: ObservableObject {
    @Published var image: UIImage?
    private var cancellables = Set<AnyCancellable>()
    private let imageManager: ImageManagerProtocol
    private let breed: Breed
    
    init(breed: Breed, imageManager: ImageManagerProtocol = ImageManager.shared) {
        self.breed = breed
        self.imageManager = imageManager
        fetchImage()
    }
    
    func fetchImage() {
        imageManager.loadImage(for: breed.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching image: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] image in
                self?.image = image
            })
            .store(in: &cancellables)
    }
}

