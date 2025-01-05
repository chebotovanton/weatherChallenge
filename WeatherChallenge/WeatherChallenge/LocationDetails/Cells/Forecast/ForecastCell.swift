//
//  ForecastCell.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

struct ForecastItem: Decodable {
    struct Weather: Decodable {
        let main: String
    }
    
    struct Main: Decodable {
        let temp: Float
    }
    
    let dt: Int
    let main: Main
    let weather: [Weather]
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
    private let forecastView = ForecastView()
    
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
        
        addSubview(statusLabel)
        statusLabel.centerInSuperview()
        
        addSubview(forecastView)
        forecastView.pinToSuperviewEdges()
    }
    
    private func updateState(newState: WeatherDataContainer<ForecastData>) {
        switch newState {
        case .loading:
            self.statusLabel.isHidden = false
            self.forecastView.isHidden = true
            self.statusLabel.text = "Loading"
        case .error(let errorDescription):
            self.statusLabel.isHidden = false
            self.forecastView.isHidden = true
            self.statusLabel.text = errorDescription
        case .loaded(let forecastData):
            self.statusLabel.isHidden = true
            self.forecastView.isHidden = false
            self.forecastView.configure(viewData: forecastData)
        }
    }
}
