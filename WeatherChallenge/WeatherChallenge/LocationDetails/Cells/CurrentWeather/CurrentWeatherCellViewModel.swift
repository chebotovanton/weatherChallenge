//
//  CurrentWeatherCellViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import Foundation

protocol CurrentWeatherServiceProtocol {
    func currentWeather(location: SearchResult) async -> Result<CurrentWeatherData, WeatherLoadingError>
}

final class CurrentWeatherCellViewModel: CurrentWeatherCellViewModelProtocol {    
    var viewData: Observable<WeatherDataContainer<CurrentWeatherData>> = Observable(.loading)
    
    private let location: SearchResult
    private let weatherLoadingService: WeatherLoadingServiceProtocol
    
    init(
        location: SearchResult,
        weatherLoadingService: WeatherLoadingServiceProtocol
    ) {
        self.location = location
        self.weatherLoadingService = weatherLoadingService
    }
    
    // WIP: Can I make this method async as well?
    func startLoadingData() {
        Task { [weak self] in
            guard let self = self else { return }
            let currentWeatherResult = await self.weatherLoadingService.currentWeather(location: location)
            
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
