//
//  CurrentWeatherItem.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

protocol CurrentWeatherCellViewModelFactoryProtocol {
    func createCurrentWeatherViewModelFactory(location: Location) -> any CurrentWeatherCellViewModelProtocol
}

final class CurrentWeatherTableItem: WeatherItemProtocol {
    private let currentWeatherCellIdentifier = "currentWeatherCellIdentifier"
    private let location: Location
    private let currentWeatherCellViewModelFactory: CurrentWeatherCellViewModelFactoryProtocol
    private var cellViewModel: CurrentWeatherCellViewModelProtocol?
    
    init(
        location: Location,
        currentWeatherCellViewModelFactory: CurrentWeatherCellViewModelFactoryProtocol
    ) {
        self.location = location
        self.currentWeatherCellViewModelFactory = currentWeatherCellViewModelFactory
    }
    
    func registerCell(tableView: UITableView) {
        tableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: currentWeatherCellIdentifier)
    }
    
    func preferredCellHeight() -> CGFloat { 300 }
    
    func createCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: currentWeatherCellIdentifier, for: indexPath)
        guard let currentWeatherCell = cell as? CurrentWeatherCell else { return cell }
        
        // TODO: This approach will make sense if we have multiple similar items, reuse cells, but don't want to reload data
        let viewModel = cellViewModel ?? currentWeatherCellViewModelFactory.createCurrentWeatherViewModelFactory(location: location)
        currentWeatherCell.configure(viewModel: viewModel)
        cellViewModel = viewModel
        
        return currentWeatherCell
    }
}
