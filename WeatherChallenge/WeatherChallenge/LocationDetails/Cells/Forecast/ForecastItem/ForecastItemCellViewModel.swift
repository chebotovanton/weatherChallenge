//
//  ForecastItemCellViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 05/01/2025.
//

import Foundation
import UIKit

final class ForecastItemCellViewModel: ForecastItemCellViewModelProtocol {
    var viewData: Observable<ForecastItemViewCell.ViewData>
    
    private let forecastItem: ForecastItem
    private var imageLoadingTask: URLSessionDataTask?
    
    init(
        forecastItem: ForecastItem
    ) {
        self.forecastItem = forecastItem
        self.viewData = Observable(
            ForecastItemViewCell.ViewData(
                timeDescription: TimestampFormatter.timestampDescription(timestamp: forecastItem.dt),
                icon: nil,
                tempDescription: TemperatureFormatter.temperatureDescription(temp: forecastItem.main.temp)
            )
        )
    }
    
    func startLoadingImage() {
        // WIP: Inject everything here
        guard let iconString = forecastItem.weather.first?.icon else { return }
        let urlString = String(format: "https://openweathermap.org/img/wn/%@@2x.png", iconString)
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        let task = URLSession(configuration: .default).dataTask(with: urlRequest) { [weak self] data, _, _ in
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

// WIP: Add tests for this
final class TemperatureFormatter {
    static func temperatureDescription(temp: Float) -> String {
        let result = String(Int(temp))
        if temp > 1 {
            return "+" + result
        } else {
            return result
        }
    }
}

final class TimestampFormatter {
    // WIP: This shouldn't be static!
    static func timestampDescription(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}
