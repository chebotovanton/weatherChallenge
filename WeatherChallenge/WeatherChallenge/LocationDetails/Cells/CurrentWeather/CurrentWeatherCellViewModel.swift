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
    var viewData: CurrentValueSubject<WeatherDataContainer<CurrentWeatherView.ViewData>, Never> = CurrentValueSubject(.loading)

    private let location: Location
    private let weatherLoadingService: CurrentWeatherLoader
    private let tempFormatter: TemperatureFormatterProtocol
    private let iconLoadingService: WeatherIconLoadingServiceProtocol

    init(
        location: Location,
        weatherLoadingService: CurrentWeatherLoader,
        tempFormatter: TemperatureFormatterProtocol,
        iconLoadingService: WeatherIconLoadingServiceProtocol
    ) {
        self.location = location
        self.weatherLoadingService = weatherLoadingService
        self.tempFormatter = tempFormatter
        self.iconLoadingService = iconLoadingService
    }
    
    func startLoadingData() {
        Task { [weak self] in
            guard let self = self else { return }
            let currentWeatherResult = await self.weatherLoadingService.makeRequest(location: location)
            
            let currentWeatherState: WeatherDataContainer = {
                switch currentWeatherResult {
                case .success(let currentWeather):
                    let viewData = self.processData(currentWeather: currentWeather)
                    return .loaded(viewData)
                case .failure(let error):
                    return .error(error.errorDescription)
                }
            }()
            
            viewData.value = currentWeatherState
        }
    }

    private func processData(currentWeather: CurrentWeatherData) -> CurrentWeatherView.ViewData {
        let viewData = CurrentWeatherView.ViewData(
            highLowViewData: CurrentWeatherView.HighLowView.ViewData(
                highTempDescription: tempFormatter.temperatureDescription(temp: currentWeather.main.temp_max),
                lowTempDescription: tempFormatter.temperatureDescription(temp: currentWeather.main.temp_min)
            ),
            icon: nil,
            weatherDescription: currentWeather.weather.first?.description ?? "Undefined",
            tempDescription: tempFormatter.temperatureDescription(temp: currentWeather.main.temp)
        )

        if let iconString = currentWeather.weather.first?.icon {
            loadWeatherImage(iconString: iconString, existingViewData: viewData)
        }

        return viewData
    }

    private let imageUrl = "https://openweathermap.org/img/wn/%@@2x.png"

    private func loadWeatherImage(iconString: String, existingViewData: CurrentWeatherView.ViewData) {
        Task { [weak self] in
            guard let self = self else { return }
            guard let image = await iconLoadingService.loadIcon(iconString: iconString) else { return }
            viewData.value = .loaded(
                CurrentWeatherView.ViewData(
                    highLowViewData: existingViewData.highLowViewData,
                    icon: image,
                    weatherDescription: existingViewData.weatherDescription,
                    tempDescription: existingViewData.tempDescription
                )
            )
        }
    }
}
