//
//  CoreDataPOCTests.swift
//  CoreDataPOCTests
//
//  Created by MahmoudFares on 28/12/2023.
//

import XCTest
@testable import CoreDataPOC

final class CoreDataPOCTests: XCTestCase {

    func testAddEvent() throws {
        // Arrange
        let initialState = AddEventViewModel.State()
        let viewModel = AddEventViewModel(repositry: .testValue, currentState: initialState)
        
        // Act
        viewModel.trigger(.submitButtonTapped)
        
        // Assert
        let expectation = self.expectation(description: "Received result successfully")

        var receivedError: Error?

        let cancellable = viewModel.resultPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // Do nothing for successful completion
                case .failure(let error):
                    receivedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, .success)
                expectation.fulfill()
            })

        waitForExpectations(timeout: 1, handler: nil)

        // Assert the result after the expectation is fulfilled
        XCTAssertNil(receivedError, "Unexpected error: \(receivedError.debugDescription)")

        // Cancel the subscription to avoid retaining it
        cancellable.cancel()
    }


    func testAddEventFail() throws {
        // Arrange
        let initialState = AddEventViewModel.State()
        let viewModel = AddEventViewModel(repositry: .fail, currentState: initialState)
        
        // Act
        viewModel.trigger(.submitButtonTapped)
        
        // Assert
        let expectation = self.expectation(description: "Received result successfully")

        var receivedError: Error?

        let cancellable = viewModel.resultPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // Do nothing for successful completion
                case .failure(let error):
                    receivedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, .fail)
                expectation.fulfill()
            })

        waitForExpectations(timeout: 1, handler: nil)

        // Assert the result after the expectation is fulfilled
        XCTAssertNil(receivedError, "Unexpected error: \(receivedError.debugDescription)")

        // Cancel the subscription to avoid retaining it
        cancellable.cancel()
    }

}
