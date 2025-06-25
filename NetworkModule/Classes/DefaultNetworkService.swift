//
//  DefaultNetworkService.swift
//  Pods
//
//  Created by Jalal Khan on 15.05.25.
//

import Foundation
import Combine

public class DefaultNetworkService: NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: [String : String]? = nil,
        body: Data? = nil,
        queryParams: [String : String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard var urlComponents = URLComponents(string: Config.shared.baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem.init(name: $0.key, value: $0.value)}
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        var defaultHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        if let headers = headers {
            defaultHeaders.merge(headers) { (_, new) in new }
        }
        defaultHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw NetworkError.decodingError
                }
            default:
                throw NetworkError.serverError(httpResponse.statusCode)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    public func requestPublisher<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: [String : String]? = nil,
        body: Data? = nil,
        queryParams: [String : String]? = nil,
        responseType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        // Build URL
        guard var urlComponents = URLComponents(string: Config.shared.baseURL + endpoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        var defaultHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        if let headers = headers {
            defaultHeaders.merge(headers) { (_, new) in new }
        }
        defaultHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        // Publisher
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                switch httpResponse.statusCode {
                case 200..<300:
                    return data
                default:
                    throw NetworkError.serverError(httpResponse.statusCode)
                }
            }
            .decode(type: T.self, decoder: {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return decoder
            }())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is DecodingError {
                    return NetworkError.decodingError
                } else {
                    return NetworkError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
