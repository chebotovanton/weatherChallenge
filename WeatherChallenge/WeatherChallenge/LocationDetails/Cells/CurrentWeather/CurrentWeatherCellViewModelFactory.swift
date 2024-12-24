//
//  CurrentWeatherCellViewModelFactory.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import Foundation

final class CurrentWeatherCellViewModelFactory: CurrentWeatherCellViewModelFactoryProtocol {
    private let urlFormatter: UrlFormatterProtocol
    private let urlSession: URLSession
    
    init(
        urlFormatter: UrlFormatterProtocol,
        urlSession: URLSession
    ) {
        self.urlFormatter = urlFormatter
        self.urlSession = urlSession
    }
    
    func createCurrentWeatherViewModelFactory(location: SearchResult) -> CurrentWeatherCellViewModel<NetworkService<CurrentWeatherData>> {
        let weatherLoadingService = NetworkService<CurrentWeatherData>(
            urlFormatter: urlFormatter,
            urlSession: urlSession
        )
        
        let viewModel = CurrentWeatherCellViewModel(
            location: location,
            weatherLoadingService: weatherLoadingService
        )
        
        return viewModel
    }
}
