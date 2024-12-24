//
//  ForecastCellViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import Foundation

final class ForecastCellViewModel<ForecastLoader>: ForecastCellViewModelProtocol
where ForecastLoader: NetworkServiceProtocol,
      ForecastLoader.ReturnType == ForecastData
{
    var viewData: Observable<WeatherDataContainer<ForecastData>> = Observable(.loading)
    
    private let location: SearchResult
    private let forecastLoadingService: ForecastLoader
    
    init(
        location: SearchResult,
        forecastLoadingService: ForecastLoader
    ) {
        self.location = location
        self.forecastLoadingService = forecastLoadingService
    }
    
    func startLoadingData() {
        Task { [weak self] in
            guard let self = self else { return }
            let currentWeatherResult = await self.forecastLoadingService.makeRequest(location: location)
            
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
