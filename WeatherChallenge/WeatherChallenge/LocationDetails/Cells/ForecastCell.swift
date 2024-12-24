//
//  ForecastCell.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

struct ForecastItem: Decodable {
    let dt: Int
}

struct ForecastData: Decodable {
    let list: [ForecastItem]
}

protocol ForecastCellViewModelProtocol {
    var viewData: Observable<WeatherDataContainer<ForecastData>> { get }
    
    func startLoadingData()
}

final class ForecastCell: UITableViewCell {
    private var viewModel: ForecastCellViewModelProtocol?
    private let statusLabel = UILabel()
    
    func configure(viewModel: ForecastCellViewModelProtocol) {
        configureAppearance()
        
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
    
    private func configureAppearance() {
        self.selectionStyle = .none
        self.backgroundColor = .green
        
        addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        statusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func updateState(newState: WeatherDataContainer<ForecastData>) {
        print(newState)
        switch newState {
        case .loading:
            self.statusLabel.text = "Loading"
        case .error(let errorDescription):
            self.statusLabel.text = errorDescription
        case .loaded(let weatherData):
            self.statusLabel.text = "Loaded"
        }
    }
}
