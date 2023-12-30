//
//  EventModel.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 28/12/2023.
//

import Foundation


extension Array where Element == EventEntity {
    static let mock: [EventEntity] = [
        .init(
            id: UUID().uuidString,
            eventName: "Event Name",
            eventImage: "",
            eventPlace: .init(lat: .random(in: 10...100), long: .random(in: 10...100)),
            eventDate: Date().addingTimeInterval(-Double.random(in: 0...(365 * 24 * 60 * 60))),
            numberOfParticipants: 1
        ),
        .init(
            id: UUID().uuidString,
            eventName: "Event Name 2",
            eventImage: "",
            eventPlace: .init(lat: .random(in: 10...100), long: .random(in: 10...100)),
            eventDate: Date().addingTimeInterval(-Double.random(in: 0...(365 * 24 * 60 * 60))),
            numberOfParticipants: 2
        ),
        .init(
            id: UUID().uuidString,
            eventName: "Event Name 3",
            eventImage: "",
            eventPlace: .init(lat: .random(in: 10...100), long: .random(in: 10...100)),
            eventDate: Date().addingTimeInterval(-Double.random(in: 0...(365 * 24 * 60 * 60))),
            numberOfParticipants: 3
        )
    ]
}
