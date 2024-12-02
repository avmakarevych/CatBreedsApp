//
//  CatBreedsAppTests.swift
//  CatBreedsAppTests
//
//  Created by Андрій Макаревич on 02.12.2024.
//
import XCTest
import Combine
@testable import CatBreedsApp

final class CatBreedsAppTests: XCTestCase {
    var viewModel: BreedViewModel!
    var mockAPI: MockCatAPI!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockAPI = MockCatAPI()
        viewModel = BreedViewModel(api: mockAPI)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        super.tearDown()
    }
    
    func testFetchBreeds_Success() {
        // Arrange
        let breeds = [
            Breed(id: "1", name: "Siamese"),
            Breed(id: "2", name: "Persian")
        ]
        mockAPI.fetchBreedsResult = Just(breeds)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "Breeds fetched successfully")
        
        // Act
        viewModel.fetchBreeds()
        
        // Assert
        viewModel.$breeds
            .dropFirst()
            .sink { fetchedBreeds in
                XCTAssertNil(self.viewModel.errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchBreeds_Failure() {
        // Arrange
        let error = URLError(.notConnectedToInternet)
        mockAPI.fetchBreedsResult = Fail(error: error).eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "Breeds fetch failed")
        
        // Act
        viewModel.fetchBreeds()
        
        // Assert
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(self.viewModel.breeds.count, 0)
                XCTAssertFalse(self.viewModel.isLoading)
                XCTAssertEqual(errorMessage, error.localizedDescription)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFilteredBreeds() {
        // Arrange
        let breeds = [
            Breed(id: "1", name: "Siamese"),
            Breed(id: "2", name: "Persian"),
            Breed(id: "3", name: "Siberian")
        ]
        viewModel.breeds = breeds
        
        // Act & Assert
        viewModel.searchText = "si"
        XCTAssertEqual(viewModel.filteredBreeds.count, 3)
        
        viewModel.searchText = "per"
        XCTAssertEqual(viewModel.filteredBreeds.count, 1)
        
        viewModel.searchText = ""
        XCTAssertEqual(viewModel.filteredBreeds.count, 3)
    }
}

