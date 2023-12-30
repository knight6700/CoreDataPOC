//
//  Strings+extensions.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 30/12/2023.
//

import Foundation
import CoreData

extension String {
    static var empty: Self = ""
}

extension NSManagedObject {
    func toDictionary() -> [String: Any]? {
        var dictionary: [String: Any] = [:]

        for (key, value) in entity.attributesByName {
            if let attributeValue = self.value(forKey: key) {
                dictionary[key] = attributeValue
            }
        }

        return dictionary
    }
}
