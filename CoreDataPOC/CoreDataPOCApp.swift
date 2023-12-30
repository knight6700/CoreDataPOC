//
//  CoreDataPOCApp.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 28/12/2023.
//

import SwiftUI

@main
struct CoreDataPOCApp: App {
    var body: some Scene {
        WindowGroup {
            EventList(
                viewModel: .init(
                    repositry: .live,
                    addEvenViewModel: .init(repositry: .live)
                )
            )        }
    }
}
