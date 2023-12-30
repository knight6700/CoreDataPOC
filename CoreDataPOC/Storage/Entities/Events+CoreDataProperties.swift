//
//  Events+CoreDataProperties.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 30/12/2023.
//
//

import Foundation
import CoreData


extension Events {
    @NSManaged public var id: String
    @NSManaged public var eventName: String
    @NSManaged public var eventImage: String?
    @NSManaged public var eventDate: Date
    @NSManaged public var numberOfParticipants: Int
    @NSManaged public var place: Place
}

extension Events : Identifiable {
    var toDictionary: [String: Any]? {
            var dictionary: [String: Any] = [
                "eventName": eventName,
                "eventImage": eventImage,
                "eventDate": eventDate,
                "numberOfParticipants": numberOfParticipants
            ]

            // Assuming Place also has a toDictionary method
            if let placeDictionary = place.toDictionary() {
                dictionary["place"] = placeDictionary
            }

            return dictionary
        }
}
