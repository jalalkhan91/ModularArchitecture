//
//  Config.swift
//  Pods
//
//  Created by Jalal Khan on 15.05.25.
//

import Foundation

enum Environment {
    case development
    case production
    
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}

struct Config {
    static let shared = Config()
    
    private init() {}
    
    var baseURL: String {
        switch Environment.current {
        case .development:
            return "https://fake-json-api.mock.beeceptor.com"
        case .production:
            return "https://fake-json-api.mock.beeceptor.com"
        }
    }    
}
