//
//  ForecastCellViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import Foundation
import Combine

final class ForecastCellViewModel<ForecastLoader>: ForecastCellViewModelProtocol
where ForecastLoader: NetworkServiceProtocol,
      ForecastLoader.ReturnType == ForecastData {
    var viewData: CurrentValueSubject<WeatherDataContainer<ForecastData>, Never> = CurrentValueSubject(.loading)

    private let location: Location
    private let forecastLoadingService: ForecastLoader
    
    init(
        location: Location,
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
            
            viewData.value = currentWeatherState
        }
    }
}
