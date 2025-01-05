//
//  ForecastItemCellViewModelFactory.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 05/01/2025.
//

import Foundation

protocol ForecastItemCellViewModelFactoryProtocol {
    func createViewModel(forecastItem: ForecastItem) -> ForecastItemCellViewModelProtocol
}

final class ForecastItemCellViewModelFactory: ForecastItemCellViewModelFactoryProtocol {
    private let urlSession: URLSession
    private let tempFormatter: TemperatureFormatterProtocol
    private let timeFormatter: TimestampFormatterProtocol

    init(
        urlSession: URLSession,
        tempFormatter: TemperatureFormatterProtocol,
        timeFormatter: TimestampFormatterProtocol
    ) {
        self.urlSession = urlSession
        self.tempFormatter = tempFormatter
        self.timeFormatter = timeFormatter
    }

    func createViewModel(forecastItem: ForecastItem) -> ForecastItemCellViewModelProtocol {
        return ForecastItemCellViewModel(
            forecastItem: forecastItem,
            tempFormatter: tempFormatter,
            timeFormatter: timeFormatter,
            urlSession: urlSession
        )
    }
}
