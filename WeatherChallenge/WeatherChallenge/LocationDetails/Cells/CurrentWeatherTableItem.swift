//
//  CurrentWeatherItem.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

final class CurrentWeatherTableItem: WeatherItemProtocol {
    private let currentWeatherCellIdentifier = "currentWeatherCellIdentifier"
    
    // WIP: Should this be hidden in another factory?
    private let location: SearchResult
    private let weatherLoadingService: WeatherLoadingServiceProtocol
    
    init(
        location: SearchResult,
        weatherLoadingService: WeatherLoadingServiceProtocol
    ) {
        self.location = location
        self.weatherLoadingService = weatherLoadingService
    }
    
    func registerCell(tableView: UITableView) {
        tableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: currentWeatherCellIdentifier)
    }
    
    func preferredCellHeight() -> CGFloat { 300 }
    
    func createCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: currentWeatherCellIdentifier, for: indexPath)
        guard let currentWeatherCell = cell as? CurrentWeatherCell else { return cell }
        
        let viewModel = CurrentWeatherCellViewModel(
            location: location,
            weatherLoadingService: weatherLoadingService
        )
        
        // WIP: Do I wanna keep the view model reference and reuse it on cell reuse?
        currentWeatherCell.configure(viewModel: viewModel)
        
        return currentWeatherCell
    }
}
