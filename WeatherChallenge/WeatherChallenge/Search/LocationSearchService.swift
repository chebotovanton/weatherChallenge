//
//  LocationSearchService.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import Foundation

enum LocationSearchError: Error {
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

protocol LocationSearchServiceProtocol {
    func search(query: String) async -> Result<[SearchResult], LocationSearchError>
}

// TODO: We can generalise NetworkService even further and use it instead of LocationSearchService
final class LocationSearchService: LocationSearchServiceProtocol {
    private let urlFormat = "http://api.openweathermap.org/geo/1.0/direct?q=%@&limit=%i&appid=%@"
    
    private let apiKeyProvider: ApiKeyProviderProtocol
    // TODO: Would be nice to hide the urlSession behind a custom protocol for testability
    private let urlSession: URLSession
    private let resultsLimit: Int
    
    init(
        apiKeyProvider: ApiKeyProviderProtocol,
        resultsLimit: Int,
        urlSession: URLSession
    ) {
        self.apiKeyProvider = apiKeyProvider
        self.resultsLimit = resultsLimit
        self.urlSession = urlSession
    }
    
    func search(query: String) async -> Result<[SearchResult], LocationSearchError> {
        // TODO: May be worthy to introduce a UrlFormatter class later, to have this logic covered with unit tests
        let urlString = String(format: urlFormat, query, resultsLimit, apiKeyProvider.apiKey)
        
        guard let url = URL(string: urlString) else {
            return .failure(.incorrectUrl)
        }
        
        guard let (data, _) = try? await urlSession.data(from: url) else {
            return .failure(.emptyResponse)
        }
        
        guard let searchResults = try? JSONDecoder().decode([SearchResult].self, from: data) else {
            return .failure(.wrongResponseFormat)
        }
        
        guard searchResults.count > 0 else {
            return .failure(.emptyResponse)
        }
        
        return .success(searchResults)
    }
}
