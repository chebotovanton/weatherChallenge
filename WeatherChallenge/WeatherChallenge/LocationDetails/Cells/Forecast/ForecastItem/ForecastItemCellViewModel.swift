//
//  ForecastItemCellViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 05/01/2025.
//

import Foundation
import Combine
import UIKit

protocol TemperatureFormatterProtocol {
    func temperatureDescription(temp: Float) -> String
}

protocol TimestampFormatterProtocol {
    func timestampDescription(timestamp: Int) -> String
}

final class ForecastItemCellViewModel: ForecastItemCellViewModelProtocol {
    let viewData: CurrentValueSubject<ForecastItemViewCell.ViewData, Never>

    private let forecastItem: ForecastItem
    private let tempFormatter: TemperatureFormatterProtocol
    private let timeFormatter: TimestampFormatterProtocol
    private let urlSession: URLSession
    private static let imageUrl = "https://openweathermap.org/img/wn/%@@2x.png"
    private var imageLoadingTask: URLSessionDataTask?
    
    init(
        forecastItem: ForecastItem,
        tempFormatter: TemperatureFormatterProtocol,
        timeFormatter: TimestampFormatterProtocol,
        urlSession: URLSession
    ) {
        self.forecastItem = forecastItem
        self.tempFormatter = tempFormatter
        self.timeFormatter = timeFormatter
        self.urlSession = urlSession

        let initialViewData = ForecastItemViewCell.ViewData(
            timeDescription: timeFormatter.timestampDescription(timestamp: forecastItem.dt),
            icon: nil,
            tempDescription: tempFormatter.temperatureDescription(temp: forecastItem.main.temp)
        )
        self.viewData = CurrentValueSubject(initialViewData)
    }
    // TODO: There's an obvious code duplication with WeatherIconLoadingService. It doesn't support loading cancellation since it has now way to distinguish existing requests
    // TODO: The solution could be based on providing unique identifiers for each image loading request, but I'm running out of time here 😅
    func startLoadingImage() {
        guard let iconString = forecastItem.weather.first?.icon else { return }
        let urlString = String(format: Self.imageUrl, iconString)
        guard let url = URL(string: urlString) else { return }
        let task = urlSession.dataTask(with: URLRequest(url: url)) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            viewData.value = ForecastItemViewCell.ViewData(
                timeDescription: viewData.value.timeDescription,
                icon: image,
                tempDescription: viewData.value.tempDescription
            )
        }
        task.resume()
    }
    
    func cancelLoadingImage() {
        imageLoadingTask?.cancel()
    }
}
