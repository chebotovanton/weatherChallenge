//
//  CurrentWeatherItem.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

protocol CurrentWeatherCellViewModelFactoryProtocol {
    // WIP: Do I have to expose the type?
    func createCurrentWeatherViewModelFactory(location: Location) -> CurrentWeatherCellViewModel<NetworkService<CurrentWeatherData>>
}

final class CurrentWeatherTableItem: WeatherItemProtocol {
    private let currentWeatherCellIdentifier = "currentWeatherCellIdentifier"
    private let location: Location
    private let currentWeatherCellViewModelFactory: CurrentWeatherCellViewModelFactoryProtocol
    
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
        
        let viewModel = currentWeatherCellViewModelFactory.createCurrentWeatherViewModelFactory(location: location)
        
        // WIP: Do I wanna keep the view model reference and reuse it on cell reuse?
        currentWeatherCell.configure(viewModel: viewModel)
        
        return currentWeatherCell
    }
}
