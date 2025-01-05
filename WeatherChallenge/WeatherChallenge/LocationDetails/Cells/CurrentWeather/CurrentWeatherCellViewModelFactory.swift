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
    private let tempFormatter: TemperatureFormatterProtocol

    init(
        urlFormatter: UrlFormatterProtocol,
        urlSession: URLSession,
        tempFormatter: TemperatureFormatterProtocol
    ) {
        self.urlFormatter = urlFormatter
        self.urlSession = urlSession
        self.tempFormatter = tempFormatter
    }
    
    func createCurrentWeatherViewModelFactory(location: Location) -> any CurrentWeatherCellViewModelProtocol {
        let weatherLoadingService = NetworkService<CurrentWeatherData>(
            urlFormatter: urlFormatter,
            urlSession: urlSession
        )
        
        let viewModel = CurrentWeatherCellViewModel(
            location: location,
            weatherLoadingService: weatherLoadingService,
            tempFormatter: tempFormatter
        )
        
        return viewModel
    }
}
