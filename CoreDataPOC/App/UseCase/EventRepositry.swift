//
//  AddEventRepo.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 30/12/2023.
//

import Foundation

struct PlaceEntity: Equatable, Hashable {
    var lat: Double
    var long: Double
    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }
    
    init (place: Place) {
        self.lat = place.lat
        self.long = place.long
    }
}
struct EventEntity: Identifiable, Equatable, Hashable {
    var id: String
    var eventName: String
    var eventImage: String?
    var eventPlace: PlaceEntity
    var eventDate: Date?
    var numberOfParticipants: Int

    init(
        id: String,
        eventName: String,
        eventImage: String?,
        eventPlace: PlaceEntity,
        eventDate: Date?,
        numberOfParticipants: Int
    ) {
        self.id = id
        self.eventName = eventName
        self.eventImage = eventImage
        self.eventPlace = eventPlace
        self.eventDate = eventDate
        self.numberOfParticipants = numberOfParticipants
    }

    init(event: Events) {
        id = event.id
        eventName = event.eventName
        eventImage = event.eventImage
        eventPlace = PlaceEntity(place: event.place)
        eventDate = event.eventDate
        numberOfParticipants = event.numberOfParticipants
    }
}

struct EventRepositry {
    var fetch: () async throws -> [EventEntity]
    var saveEvent: (_ parameters: EventEntity) async throws -> Void
    var delete: (_ parameters: EventEntity,_ id: String) async throws -> Void
}

extension EventRepositry {
    static let live: Self = Self(
        fetch: {
            let events = try await CoreDataManager.shared.fetch(Events.self)
            let toDomain = events.map { EventEntity(event: $0) }
            return toDomain
        }, saveEvent: { parameters in
            let context = CoreDataStack.shared.mainContext
            let event = Events(context: context)
            let place = Place(context: context)
            context.reset()
            place.lat = parameters.eventPlace.lat
            place.long = parameters.eventPlace.long
            event.id = parameters.id
            event.eventName = parameters.eventName
            event.eventImage = parameters.eventImage
            event.place = place
            event.eventDate = parameters.eventDate ?? .now
            event.numberOfParticipants = parameters.numberOfParticipants
            try await CoreDataManager.shared.saveElement(event)
        }, delete: { parameters, index in
            try await CoreDataManager.shared.delete(Events.self,id: parameters.id)
        }
    )
}

extension EventRepositry {
    static let preview: Self = Self(
        fetch: {
            .mock
        }, saveEvent: { _ in },
        delete: { _,_  in }
    )

    static let testValue: Self = .preview

    static let fail: Self = .init(
        fetch: {
            throw StorageError.unExpecterror("can't fetch")
        }, saveEvent: { _ in
            throw StorageError.unExpecterror("Error")
        },delete: { _,_  in throw StorageError.unExpecterror("can't Deleted") }
    )
}
