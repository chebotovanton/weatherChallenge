//
//  WeatherLoadingService.swift
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

protocol WeatherLoadingServiceProtocol {
    func currentWeather(location: SearchResult) async -> Result<CurrentWeatherData, WeatherLoadingError>
}

final class WeatherLoadingService: WeatherLoadingServiceProtocol {
    // TODO: Would be nice not to keep the keys openly
    private let apiKey = "3e5afd29dd22c6c30c3f02832b405045"
    private let urlFormat = "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@"
    
    // TODO: Would be nice to hide the urlSession behind a custom protocol for testability
    private let urlSession: URLSession
    
    init(
        urlSession: URLSession
    ) {
        self.urlSession = urlSession
    }
    
    func currentWeather(location: SearchResult) async -> Result<CurrentWeatherData, WeatherLoadingError> {
        // TODO: May be worthy to introduce a UrlFormatter class later, to have this logic covered with unit tests
        let urlString = String(format: urlFormat, location.lat, location.lon, apiKey)
        
        guard let url = URL(string: urlString) else {
            return .failure(.incorrectUrl)
        }
        
        guard let (data, _) = try? await urlSession.data(from: url) else {
            return .failure(.emptyResponse)
        }
        
        guard let currentWeatherData = try? JSONDecoder().decode(CurrentWeatherData.self, from: data) else {
            return .failure(.wrongResponseFormat)
        }
                
        return .success(currentWeatherData)
    }
}

// WIP: Unify services using generics
