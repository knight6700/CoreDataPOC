//
//  EventsViewModel.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 30/12/2023.
//

import Foundation
class EventsViewModel: ViewModelBase {
    struct State: Equatable {
        var events: [EventEntity] = []
    }

    enum Action: Equatable {
        case fetch
        case delete(id: Int)
    }

    var repositry: EventRepositry
    var addEvenViewModel: AddEventViewModel

    init(
        repositry: EventRepositry,
        currentState: State = .init(),
        addEvenViewModel: AddEventViewModel
    ) {
        self.repositry = repositry
        self.currentState = currentState
        self.addEvenViewModel = addEvenViewModel
    }

    @Published var currentState: State = .init()

    func trigger(_ action: Action) {
        switch action {
        case .fetch:
            fetchEvents()
        case .delete(let id):
            deleteEvent(id: id)
        }
    }
    
    func deleteEvent(id: Int) {
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
             let event = currentState.events[id] 
            do {
                _ = try await repositry.delete(event,id)
                currentState.events.removeAll(where: {$0 == event})
            } catch {
                print(error)
            }
        }
    }
    
    func fetchEvents() {
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            do {
                let events = try await repositry.fetch()
                self.currentState.events = events
            } catch {
                print(error)
            }
        }
    }
}
