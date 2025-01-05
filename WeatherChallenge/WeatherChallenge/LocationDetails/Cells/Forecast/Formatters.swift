//
//  Formatters.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 05/01/2025.
//

import Foundation

// WIP: Add tests for this
final class TemperatureFormatter: TemperatureFormatterProtocol {
    func temperatureDescription(temp: Float) -> String {
        let result = String(Int(temp)) + "°"
        if temp > 1 {
            return "+" + result
        } else {
            return result
        }
    }
}

final class TimestampFormatter: TimestampFormatterProtocol {
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = .current
        return dateFormatter
    }()

    func timestampDescription(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return dateFormatter.string(from: date)
    }
}
