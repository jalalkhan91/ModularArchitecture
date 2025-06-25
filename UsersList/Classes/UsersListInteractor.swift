//
//  UsersListInteractor.swift
//  Pods
//
//  Created by Jalal Khan on 15.05.25.
//

import Foundation
import NetworkModule

public protocol UsersListInteractor {
    var state: UsersListState { get }
    
    func onViewAppear()
}


public class UsersListInteractorLive: UsersListInteractor {
    public var state: UsersListState
    private let networkModule: NetworkModule
    
    public init(state: UsersListState, networkModule: NetworkModule) {
        self.state = state
        self.networkModule = networkModule
    }
    
    public func onViewAppear() {
        Task {
            await getUsers()
        }
    }
    
    @MainActor
    private func getUsers() async {
        state.isLoading = true
        state.error = nil
        
        do {
            let users = try await networkModule.get(
                endpoint: "/users",
                responseType: [User].self
            )
            state.isLoading = false
            state.users = users
        } catch {
            state.isLoading = false
            state.error = error.localizedDescription
        }
    }
}
