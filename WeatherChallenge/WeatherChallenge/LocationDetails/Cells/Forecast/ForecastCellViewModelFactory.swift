//
//  ForecastCellViewModelFactory.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import Foundation

final class ForecastCellViewModelFactory: ForecastCellViewModelFactoryProtocol {
    private let apiKeyProvider: ApiKeyProvider
    private let urlSession: URLSession
    
    init(
        apiKeyProvider: ApiKeyProvider,
        urlSession: URLSession
    ) {
        self.apiKeyProvider = apiKeyProvider
        self.urlSession = urlSession
    }
    
    func createForecastCellViewModelFactory(location: SearchResult) -> ForecastCellViewModel<ForecastLoadingService<ForecastData>> {
        let forecastLoadingService = ForecastLoadingService<ForecastData>(
            apiKeyProvider: apiKeyProvider,
            urlFormat: "https://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&appid=%@",
            urlSession: urlSession
        )
        
        let viewModel = ForecastCellViewModel(
            location: location,
            forecastLoadingService: forecastLoadingService
        )
        
        return viewModel
    }
}
