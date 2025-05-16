//
//  UsersListInteractor.swift
//  Pods
//
//  Created by Jalal Khan on 15.05.25.
//

import Foundation
import NetworkModule

public protocol UsersListInteractor: AnyObject {
    var state: UsersListState { get }
    
    func viewOnAppear()
    
}

public final class UsersListInteractorLive: UsersListInteractor {
    public var state: UsersListState
    private let networkModule: NetworkModule
    
    public init(state: UsersListState, networkModule: NetworkModule) {
        self.state = state
        self.networkModule = networkModule
    }
    
    public func viewOnAppear() {
        Task {
            await fetchUsers()
        }
    }
    
    @MainActor
    private func fetchUsers() async {
        state.isLoading = true
        state.error = nil
        
        do {
            let users: [User] = try await networkModule.get(
                endpoint: "/users",
                responseType: [User].self
            )
            
            state.users = users
            state.isLoading = false
        } catch {
            state.error = error.localizedDescription
            state.isLoading = false
        }
    }
}
