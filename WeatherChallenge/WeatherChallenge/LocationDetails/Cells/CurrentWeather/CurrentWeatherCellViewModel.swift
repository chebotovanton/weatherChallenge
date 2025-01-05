//
//  CurrentWeatherCellViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import Foundation
import Combine

final class CurrentWeatherCellViewModel<CurrentWeatherLoader>: CurrentWeatherCellViewModelProtocol
where CurrentWeatherLoader: NetworkServiceProtocol,
      CurrentWeatherLoader.ReturnType == CurrentWeatherData {
    var viewData: CurrentValueSubject<WeatherDataContainer<CurrentWeatherData>, Never> = CurrentValueSubject(.loading)

    private let location: Location
    private let weatherLoadingService: CurrentWeatherLoader
    
    init(
        location: Location,
        weatherLoadingService: CurrentWeatherLoader
    ) {
        self.location = location
        self.weatherLoadingService = weatherLoadingService
    }
    
    func startLoadingData() {
        Task { [weak self] in
            guard let self = self else { return }
            let currentWeatherResult = await self.weatherLoadingService.makeRequest(location: location)
            
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
