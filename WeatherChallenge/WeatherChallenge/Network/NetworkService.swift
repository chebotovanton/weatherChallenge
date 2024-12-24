//
//  NetworkService.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import Foundation

enum WeatherLoadingError: Error {
    case incorrectUrl
    case wrongResponseFormat
    case emptyResponse
    
    // TODO: would be nice to localize this
    public var errorDescription: String {
        switch self {
        case .incorrectUrl:
            "Incorrect search url"
        case .wrongResponseFormat:
            "Unexpected response format"
        case .emptyResponse:
            "Nothing found"
        }
    }
}

protocol NetworkServiceProtocol {
    associatedtype ReturnType: Decodable
    
    func makeRequest(location: SearchResult) async -> Result<ReturnType, WeatherLoadingError>
}

final class NetworkService<ReturnType>: NetworkServiceProtocol where ReturnType: Decodable {
    // TODO: Would be nice to hide the urlSession behind a custom protocol for testability
    private let urlSession: URLSession
    private let urlFormatter: UrlFormatterProtocol
    
    init(
        urlFormatter: UrlFormatterProtocol,
        urlSession: URLSession
    ) {
        self.urlFormatter = urlFormatter
        self.urlSession = urlSession
    }
    
    func makeRequest(location: SearchResult) async -> Result<ReturnType, WeatherLoadingError> {
        let urlString = urlFormatter.urlString(location: location)
        
        guard let url = URL(string: urlString) else {
            return .failure(.incorrectUrl)
        }
        
        guard let (data, _) = try? await urlSession.data(from: url) else {
            return .failure(.emptyResponse)
        }
        
        guard let forecastData = try? JSONDecoder().decode(ReturnType.self, from: data) else {
            return .failure(.wrongResponseFormat)
        }
        
        return .success(forecastData)
    }
}
