//
//  NetworkModule.swift
//  Pods
//
//  Created by Jalal Khan on 15.05.25.
//

import Foundation

public class NetworkModule {
    private let networkService: NetworkService
    
    public init(session: URLSession = .shared) {
        self.networkService = DefaultNetworkService(session: session)
    }
    
    public func get<T: Decodable>(
        endpoint: String,
        headers: [String: String]? = nil ,
        queryParams: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await networkService.request(
            endpoint: endpoint,
            method: .get,
            headers: headers,
            body: nil,
            queryParams: queryParams,
            responseType: responseType
        )
    }
    
    public func post<T: Decodable>(
        endpoint: String,
        body: Encodable,
        headers: [String: String]? = nil ,
        responseType: T.Type
    ) async throws -> T {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try encoder.encode(body)
        
        return try await networkService.request(
            endpoint: endpoint,
            method: .get,
            headers: headers,
            body: jsonData,
            queryParams: nil,
            responseType: responseType
        )
    }
}
