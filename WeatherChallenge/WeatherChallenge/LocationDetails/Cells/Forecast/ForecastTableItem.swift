//
//  ForecastTableItem.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

protocol ForecastCellViewModelFactoryProtocol {
    // WIP: Do I have to expose the type?
    func createForecastCellViewModelFactory(location: SearchResult) -> ForecastCellViewModel<NetworkService<ForecastData>>
}

final class ForecastTableItem: WeatherItemProtocol {
    private let forecastCellIdentifier = "forecastCellIdentifier"
    private let location: SearchResult
    private let forecastCellViewModelFactory: ForecastCellViewModelFactoryProtocol
    
    init(
        location: SearchResult,
        forecastCellViewModelFactory: ForecastCellViewModelFactoryProtocol
    ) {
        self.location = location
        self.forecastCellViewModelFactory = forecastCellViewModelFactory
    }
    
    func registerCell(tableView: UITableView) {
        tableView.register(ForecastCell.self, forCellReuseIdentifier: forecastCellIdentifier)
    }
    
    func preferredCellHeight() -> CGFloat { 120 }
    
    func createCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: forecastCellIdentifier, for: indexPath)
        guard let currentWeatherCell = cell as? ForecastCell else { return cell }
        
        // WIP: Do I wanna keep the view model reference and reuse it on cell reuse?
        let viewModel = forecastCellViewModelFactory.createForecastCellViewModelFactory(location: location)
        currentWeatherCell.configure(viewModel: viewModel)
        
        return currentWeatherCell
    }
}
