//
//  User.swift
//  Pods
//
//  Created by Jalal Khan on 15.05.25.
//

import Foundation

public struct User: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let email: String
    public let phone: String
    public let photoURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
        case photoURL = "photo"
    }
    
    public init(id: Int, name: String, email: String, phone: String, photoURL: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.photoURL = photoURL
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        photoURL = try container.decode(String.self, forKey: .photoURL)
    }
    
}


