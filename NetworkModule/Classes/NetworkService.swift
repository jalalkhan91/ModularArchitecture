//
//  NetworkService.swift
//  Pods
//
//  Created by Jalal Khan on 15.05.25.
//

import Foundation
import Combine

public protocol NetworkService {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?,
        queryParams: [String:String]?,
        responseType: T.Type
    ) async throws -> T
    
    func requestPublisher<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?,
        queryParams: [String:String]?,
        responseType: T.Type
    ) -> AnyPublisher<T, NetworkError>
}

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}

public enum NetworkError: Error {
    case invalidURL
    case decodingError
    case networkError(Error)
    case serverError(Int)
    case invalidResponse
}
