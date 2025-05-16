//
//  UsersListState.swift
//  Pods
//
//  Created by Jalal Khan on 15.05.25.
//

import Foundation
import NetworkModule

public final class UsersListState: ObservableObject {
    @Published public var users: [User] = []
    @Published public var isLoading: Bool = false
    @Published public var error: String?
}
