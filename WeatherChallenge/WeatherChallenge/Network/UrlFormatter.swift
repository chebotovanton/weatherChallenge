//
//  UrlFormatter.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

protocol UrlFormatterProtocol {
    func urlString(location: Location) -> String
}

final class UrlFormatter: UrlFormatterProtocol {
    private let urlFormat: String
    private let apiKeyProvider: ApiKeyProviderProtocol
    
    init(urlFormat: String, apiKeyProvider: ApiKeyProviderProtocol) {
        self.urlFormat = urlFormat
        self.apiKeyProvider = apiKeyProvider
    }
    
    func urlString(location: Location) -> String {
        return String(format: urlFormat, location.lat, location.lon, apiKeyProvider.apiKey) + "&units=metric"
    }
}
