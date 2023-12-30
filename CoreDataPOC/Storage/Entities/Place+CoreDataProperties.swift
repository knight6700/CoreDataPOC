//
//  Place+CoreDataProperties.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 30/12/2023.
//
//

import Foundation
import CoreData


extension Place {
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
}

extension Place : Identifiable {

}
