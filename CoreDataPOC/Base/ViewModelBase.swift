//
//  ViewModelBase.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 30/12/2023.
//

import Foundation
protocol ViewModelBase: ObservableObject {
    associatedtype State
    associatedtype Action

    var currentState: State { get }

    // Function to trigger an action
    func trigger(_ action: Action)

}
