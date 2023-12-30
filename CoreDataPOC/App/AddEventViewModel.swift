//
//  AddEventViewModel.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 30/12/2023.
//

import Foundation

class AddEventViewModel: ViewModelBase {
    struct State: Equatable {
        var id: String = .empty
        var eventName: String = .empty
        var eventImage: String = .empty
        var lat: Double = .zero
        var long: Double = .zero
        var eventDate: Date = .now
        var numberOfParticipants: Int = .zero

        var parameters: EventEntity {
            .init(
                id: UUID().uuidString,
                eventName: eventName,
                eventImage: eventImage,
                eventPlace: .init(
                    lat: lat,
                    long: long
                ),
                eventDate: eventDate,
                numberOfParticipants: numberOfParticipants
            )
        }
    }

    enum Action: Equatable {
        case submitButtonTapped
        case selectedImage(imageBase65: String)
    }

    var repositry: EventRepositry

    init(
        repositry: EventRepositry,
        currentState: State = .init()
    ) {
        self.repositry = repositry
        self.currentState = currentState
    }

    @Published var currentState: State = .init()

    func trigger(_ action: Action) {
        switch action {
        case .submitButtonTapped:
            submitEvent()
        case let .selectedImage(imageBase65: imageBase65):
            currentState.eventImage = imageBase65
        }
    }

    func submitEvent() {
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            do {
                try await repositry.saveEvent(self.currentState.parameters)
            } catch {
                print(error)
            }
        }
    }
}
