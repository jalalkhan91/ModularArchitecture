//
//  UsersListView.swift
//  Pods
//
//  Created by Jalal Khan on 15.05.25.
//

import SwiftUI

public struct UsersListView: View {
    var interactor: UsersListInteractor?
    @ObservedObject var state: UsersListState
    
    public init(interactor: UsersListInteractor?, state: UsersListState) {
        self.interactor = interactor
        self.state = state
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                if state.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let error = state.error {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text("Error Loading Data")
                            .font(.title)
                            .foregroundColor(.red)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Retry") {
                            interactor?.onViewAppear()
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    List(state.users) { user in
                        HStack(spacing: 16) {
                            AsyncImage(url: URL(string: user.photoURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(user.name)
                                    .font(.headline)
                                
                                HStack {
                                    Image(systemName: "envelope")
                                        .foregroundColor(.blue)
                                    Text(user.email)
                                        .font(.subheadline)
                                }
                                
                                HStack {
                                    Image(systemName: "phone")
                                        .foregroundColor(.green)
                                    Text(user.phone)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        interactor?.onViewAppear()
                    }
                }
            }
            .navigationTitle("Users")
        }
        .onAppear {
            interactor?.onViewAppear()
        }
    }
}

#Preview {
    UsersListView(interactor: nil, state: UsersListState())
}
