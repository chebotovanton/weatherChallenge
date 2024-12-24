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
    
    func configure(viewModel: ForecastCellViewModelProtocol) {
        self.selectionStyle = .none
        self.backgroundColor = .green
        
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
    
    private func updateState(newState: WeatherDataContainer<ForecastData>) {
        print(newState)
//        switch newState {
//        case .loading:
//            self.statusLabel.text = "Loading"
//        case .error(let errorDescription):
//            self.statusLabel.text = errorDescription
//        case .loaded(let weatherData):
//            self.statusLabel.text = weatherData.description
//        }
    }
}
