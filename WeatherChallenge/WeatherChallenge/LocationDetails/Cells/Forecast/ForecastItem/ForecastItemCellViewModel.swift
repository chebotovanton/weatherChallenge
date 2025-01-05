//
//  ForecastItemCellViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 05/01/2025.
//

import Foundation
import UIKit

protocol TemperatureFormatterProtocol {
    func temperatureDescription(temp: Float) -> String
}

protocol TimestampFormatterProtocol {
    func timestampDescription(timestamp: Int) -> String
}

final class ForecastItemCellViewModel: ForecastItemCellViewModelProtocol {
    var viewData: Observable<ForecastItemViewCell.ViewData>
    
    private let forecastItem: ForecastItem
    private let tempFormatter: TemperatureFormatterProtocol
    private let timeFormatter: TimestampFormatterProtocol
    private static let imageUrl = "https://openweathermap.org/img/wn/%@@2x.png"
    private var imageLoadingTask: URLSessionDataTask?
    
    init(
        forecastItem: ForecastItem,
        tempFormatter: TemperatureFormatterProtocol,
        timeFormatter: TimestampFormatterProtocol
    ) {
        self.forecastItem = forecastItem
        self.tempFormatter = tempFormatter
        self.timeFormatter = timeFormatter
        
        self.viewData = Observable(
            ForecastItemViewCell.ViewData(
                timeDescription: timeFormatter.timestampDescription(timestamp: forecastItem.dt),
                icon: nil,
                tempDescription: tempFormatter.temperatureDescription(temp: forecastItem.main.temp)
            )
        )
    }
    
    func startLoadingImage() {
        // WIP: Inject URLSession, limit the number of parallel loads
        guard let iconString = forecastItem.weather.first?.icon else { return }
        let urlString = String(format: Self.imageUrl, iconString)
        guard let url = URL(string: urlString) else { return }
        let task = URLSession(configuration: .default).dataTask(with: URLRequest(url: url)) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                viewData.value = ForecastItemViewCell.ViewData(
                    timeDescription: viewData.value.timeDescription,
                    icon: image,
                    tempDescription: viewData.value.tempDescription
                )
            }
        }
        task.resume()
    }
    
    func cancelLoadingImage() {
        imageLoadingTask?.cancel()
    }
}
