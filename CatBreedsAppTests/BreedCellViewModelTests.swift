//
//  BreedCellViewModelTests.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//
import XCTest
import Combine
import UIKit
@testable import CatBreedsApp

final class BreedCellViewModelTests: XCTestCase {
    var viewModel: BreedCellViewModel!
    var mockImageManager: MockImageManager!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockImageManager = MockImageManager()
        let breed = Breed(id: "1", name: "Siamese")
        viewModel = BreedCellViewModel(breed: breed, imageManager: mockImageManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockImageManager = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchImage_Success() {
        // Arrange
        let image = UIImage()
        mockImageManager.loadImageResult = Just(image)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = self.expectation(description: "Image fetched successfully")
        
        viewModel.$image
            .dropFirst()
            .sink { fetchedImage in
                // Assert
                XCTAssertNotNil(fetchedImage)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Act
        viewModel.fetchImage()
        
        // Wait for expectations
        waitForExpectations(timeout: 1.0)
    }
}

