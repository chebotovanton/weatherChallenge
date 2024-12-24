//
//  ForecastTableItem.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

final class ForecastTableItem: WeatherItemProtocol {
    private let forecastCellIdentifier = "forecastCellIdentifier"
    
    // TODO: This can be hidden in another factory for modularisation purpose
    private let location: SearchResult
    private let forecastLoadingService: ForecastLoadingServiceProtocol
    
    init(
        location: SearchResult,
        forecastLoadingService: ForecastLoadingServiceProtocol
    ) {
        self.location = location
        self.forecastLoadingService = forecastLoadingService
    }
    
    func registerCell(tableView: UITableView) {
        tableView.register(ForecastCell.self, forCellReuseIdentifier: forecastCellIdentifier)
    }
    
    func preferredCellHeight() -> CGFloat { 120 }
    
    func createCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: forecastCellIdentifier, for: indexPath)
        guard let currentWeatherCell = cell as? ForecastCell else { return cell }
        
        let viewModel = ForecastCellViewModel(
            location: location,
            forecastLoadingService: forecastLoadingService
        )
        
        // WIP: Do I wanna keep the view model reference and reuse it on cell reuse?
        currentWeatherCell.configure(viewModel: viewModel)
        
        return currentWeatherCell
    }
}
