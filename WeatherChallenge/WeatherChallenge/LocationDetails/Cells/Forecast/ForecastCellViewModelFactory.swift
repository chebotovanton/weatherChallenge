//
//  ForecastCellViewModelFactory.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import Foundation

final class ForecastCellViewModelFactory: ForecastCellViewModelFactoryProtocol {
    
    private let urlFormatter: UrlFormatterProtocol
    private let urlSession: URLSession
    
    init(
        urlFormatter: UrlFormatterProtocol,
        urlSession: URLSession
    ) {
        self.urlFormatter = urlFormatter
        self.urlSession = urlSession
    }
    
    func createForecastCellViewModelFactory(location: Location) -> any ForecastCellViewModelProtocol {
        let forecastLoadingService = NetworkService<ForecastData>(
            urlFormatter: urlFormatter,
            urlSession: urlSession
        )
        
        let viewModel = ForecastCellViewModel(
            location: location,
            forecastLoadingService: forecastLoadingService
        )
        
        return viewModel
    }
}
