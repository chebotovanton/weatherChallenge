//
//  ForecastTableItem.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

protocol ForecastCellViewModelFactoryProtocol {
    func createForecastCellViewModelFactory(location: Location) -> any ForecastCellViewModelProtocol
}

final class ForecastTableItem: WeatherItemProtocol {
    private let forecastCellIdentifier = "forecastCellIdentifier"
    private let location: Location
    private let forecastCellViewModelFactory: ForecastCellViewModelFactoryProtocol
    private let forecastItemCellViewModelFactory: ForecastItemCellViewModelFactoryProtocol
    private var cellViewModel: ForecastCellViewModelProtocol?
    
    init(
        location: Location,
        forecastCellViewModelFactory: ForecastCellViewModelFactoryProtocol,
        forecastItemCellViewModelFactory: ForecastItemCellViewModelFactoryProtocol
    ) {
        self.location = location
        self.forecastCellViewModelFactory = forecastCellViewModelFactory
        self.forecastItemCellViewModelFactory = forecastItemCellViewModelFactory
    }
    
    func registerCell(tableView: UITableView) {
        tableView.register(ForecastCell.self, forCellReuseIdentifier: forecastCellIdentifier)
    }

    func preferredCellHeight() -> CGFloat { 120 }

    func createCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: forecastCellIdentifier, for: indexPath)
        guard let currentWeatherCell = cell as? ForecastCell else { return cell }

        // TODO: This approach will make sense if we have multiple similar items, reuse cells, but don't want to reload data
        let viewModel = cellViewModel ?? forecastCellViewModelFactory.createForecastCellViewModelFactory(location: location)
        currentWeatherCell.configure(
            viewModel: viewModel,
            forecastItemCellViewModelFactory: forecastItemCellViewModelFactory
        )
        cellViewModel = viewModel
        
        return currentWeatherCell
    }
}
