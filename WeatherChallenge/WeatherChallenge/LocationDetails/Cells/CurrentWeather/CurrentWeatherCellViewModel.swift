//
//  CurrentWeatherCellViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import Foundation
import Combine

// WIP: Get rid of this import?
import UIKit

final class CurrentWeatherCellViewModel<CurrentWeatherLoader>: CurrentWeatherCellViewModelProtocol
where CurrentWeatherLoader: NetworkServiceProtocol,
      CurrentWeatherLoader.ReturnType == CurrentWeatherData {
    var viewData: CurrentValueSubject<WeatherDataContainer<CurrentWeatherView.ViewData>, Never> = CurrentValueSubject(.loading)

    private let location: Location
    private let weatherLoadingService: CurrentWeatherLoader
    private let tempFormatter: TemperatureFormatterProtocol

    init(
        location: Location,
        weatherLoadingService: CurrentWeatherLoader,
        tempFormatter: TemperatureFormatterProtocol
    ) {
        self.location = location
        self.weatherLoadingService = weatherLoadingService
        self.tempFormatter = tempFormatter
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

    // WIP: Inject an imageLoading service to avoid code duplication
    private func loadWeatherImage(iconString: String, existingViewData: CurrentWeatherView.ViewData) {
        let urlString = String(format: imageUrl, iconString)
        guard let url = URL(string: urlString) else { return }
        let task = URLSession(configuration: .default).dataTask(with: URLRequest(url: url)) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            viewData.value = .loaded(
                CurrentWeatherView.ViewData(
                    highLowViewData: existingViewData.highLowViewData,
                    icon: image,
                    weatherDescription: existingViewData.weatherDescription,
                    tempDescription: existingViewData.tempDescription
                )
            )
        }
        task.resume()
    }
}
