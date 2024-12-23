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

final class LocationSearchService: LocationSearchServiceProtocol {
    private let apiKey = "3e5afd29dd22c6c30c3f02832b405045"
    private let urlFormat = "http://api.openweathermap.org/geo/1.0/direct?q=%@&limit=%i&appid=%@"
    
    // TODO: Would be nice to hide the urlSession behind a custom protocol for testability
    private let urlSession: URLSession
    private let resultsLimit: Int
    
    init(
        resultsLimit: Int,
        urlSession: URLSession
    ) {
        self.resultsLimit = resultsLimit
        self.urlSession = urlSession
    }
    
    func search(query: String) async -> Result<[SearchResult], LocationSearchError> {
        let urlString = String(format: urlFormat, query, resultsLimit, apiKey)
        
        guard let url = URL(string: urlString) else {
            return .failure(.incorrectUrl)
        }
        
        guard let (data, _) = try? await urlSession.data(from: url) else {
            return .failure(.emptyResponse)
        }
        
        guard let searchResults = try? JSONDecoder().decode([SearchResult].self, from: data) else {
            return .failure(.wrongResponseFormat)
        }
        
        return .success(searchResults)
    }
}
