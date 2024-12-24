//
//  ForecastCellViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import Foundation

protocol ForecastLoadingServiceProtocol {
    func weatherForecast(location: SearchResult) async -> Result<ForecastData, WeatherLoadingError>
}

final class ForecastCellViewModel: ForecastCellViewModelProtocol {
    var viewData: Observable<WeatherDataContainer<ForecastData>> = Observable(.loading)
    
    private let location: SearchResult
    private let forecastLoadingService: ForecastLoadingServiceProtocol
    
    init(
        location: SearchResult,
        forecastLoadingService: ForecastLoadingServiceProtocol
    ) {
        self.location = location
        self.forecastLoadingService = forecastLoadingService
    }
    
    func startLoadingData() {
        Task { [weak self] in
            guard let self = self else { return }
            let currentWeatherResult = await self.forecastLoadingService.weatherForecast(location: location)
            
            let currentWeatherState: WeatherDataContainer = {
                switch currentWeatherResult {
                case .success(let currentWeather):
                    return .loaded(currentWeather)
                case .failure(let error):
                    return .error(error.errorDescription)
                }
            }()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.viewData.value = currentWeatherState
            }
        }
    }
}
