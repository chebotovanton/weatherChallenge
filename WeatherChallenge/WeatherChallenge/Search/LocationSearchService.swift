//
//  LocationSearchService.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

enum LocationSearchError: Error {
    case wrongUrl
    case wrongResponseFormat
    case emptyResponse
    
    // TODO: would be nice to localize this
    public var errorDescription: String {
        switch self {
        case .wrongUrl:
            "Incorrect search url"
        case .wrongResponseFormat:
            "Unexpected response format"
        case .emptyResponse:
            "Nothing found"
        }
    }
}

typealias LocationSearchCompletionBlock = (Result<[SearchResult], LocationSearchError>) -> Void

protocol LocationSearchServiceProtocol {
    func search(query: String, completion: LocationSearchCompletionBlock)
}


final class LocationSearchService: LocationSearchServiceProtocol {
    func search(
        query: String,
        completion: (Result<[SearchResult], LocationSearchError>) -> Void
    ) {
        // WIP: Perform actual search here
    }
}
