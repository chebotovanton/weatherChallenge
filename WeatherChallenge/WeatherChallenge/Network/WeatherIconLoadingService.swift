//
//  WeatherIconLoadingService.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 05/01/2025.
//

import UIKit

protocol WeatherIconLoadingServiceProtocol {
    func loadIcon(iconString: String) async -> UIImage?
}

final class WeatherIconLoadingService: WeatherIconLoadingServiceProtocol {
    private static let imageUrl = "https://openweathermap.org/img/wn/%@@2x.png"

    func loadIcon(iconString: String) async -> UIImage? {
        let urlString = String(format: Self.imageUrl, iconString)
        guard let url = URL(string: urlString) else { return nil }
        guard let (data, _) = try? await URLSession(configuration: .default).data(for: URLRequest(url: url)),
              let image = UIImage(data: data) else { return nil }
        return image
    }
}
