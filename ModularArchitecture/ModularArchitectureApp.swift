//
//  ModularArchitectureApp.swift
//  ModularArchitecture
//
//  Created by Jalal Khan on 15.05.25.
//

import NetworkModule
import SwiftUI
import UsersList

@main
struct ModularArchitectureApp: App {
    private let networkModule = NetworkModule()
    private let state = UsersListState()
    private var interactor: UsersListInteractor?
    
    init() {
        interactor = UsersListInteractorLive(
            state: state,
            networkModule: networkModule
        )
    }
    
    var body: some Scene {
        WindowGroup {
            UsersListView(interactor: interactor, state: state)
        }
    }
}
