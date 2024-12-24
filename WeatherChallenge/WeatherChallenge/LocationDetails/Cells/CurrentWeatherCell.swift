//
//  CurrentWeatherCell.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

struct CurrentWeatherData: Decodable {
    let description: String
}

protocol CurrentWeatherCellViewModelProtocol {
    var viewData: Observable<WeatherDataContainer<CurrentWeatherData>> { get }
    
    func startLoadingData()
}

final class CurrentWeatherCell: UITableViewCell {
    private var viewModel: CurrentWeatherCellViewModelProtocol?
    private let statusLabel = UILabel()
    
    func configure(viewModel: CurrentWeatherCellViewModelProtocol) {
        self.selectionStyle = .none
        self.backgroundColor = .yellow
        
        self.viewModel = viewModel
        
        self.viewModel?.viewData.subscribe(
            observer: self,
            block: { [weak self] newValue, oldValue in
                guard let self = self else { return }
                self.updateState(newState: newValue)
            }
        )
        
        self.updateState(newState: viewModel.viewData.value)
        
        viewModel.startLoadingData()
    }
    
    private func updateState(newState: WeatherDataContainer<CurrentWeatherData>) {
        switch newState {
        case .loading:
            self.statusLabel.text = "Loading"
        case .error(let errorDescription):
            self.statusLabel.text = errorDescription
        case .loaded(let weatherData):
            self.statusLabel.text = weatherData.description
        }
    }
}
