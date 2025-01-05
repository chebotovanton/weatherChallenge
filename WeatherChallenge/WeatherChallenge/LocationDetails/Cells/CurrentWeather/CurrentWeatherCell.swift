//
//  CurrentWeatherCell.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit
import Combine

struct CurrentWeatherData: Decodable {
    struct Weather: Decodable {
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Decodable {
        let temp: Float
        let temp_min: Float
        let temp_max: Float
    }
    
    let weather: [Weather]
    let main: Main
}

protocol CurrentWeatherCellViewModelProtocol {
    var viewData: CurrentValueSubject<WeatherDataContainer<CurrentWeatherView.ViewData>, Never> { get }

    func startLoadingData()
}

final class CurrentWeatherCell: UITableViewCell {
    private var viewModel: CurrentWeatherCellViewModelProtocol?
    private let statusLabel = UILabel()
    private let weatherView = CurrentWeatherView()
    private var viewDataObserver: AnyCancellable?

    func configure(viewModel: CurrentWeatherCellViewModelProtocol) {
        configureAppearance()
        
        self.viewModel = viewModel
        
        viewDataObserver = viewModel.viewData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in self?.updateState(newState: newValue) }

        viewModel.startLoadingData()
    }
    
    private func configureAppearance() {
        selectionStyle = .none
        
        addSubview(statusLabel)
        statusLabel.centerInSuperview()
        
        addSubview(weatherView)
        weatherView.pinToSuperviewEdges()
    }
    
    private func updateState(newState: WeatherDataContainer<CurrentWeatherView.ViewData>) {
        switch newState {
        case .loading:
            self.statusLabel.isHidden = false
            self.weatherView.isHidden = true
            self.statusLabel.text = "Loading"
        case .error(let errorDescription):
            self.statusLabel.isHidden = false
            self.weatherView.isHidden = true
            self.statusLabel.text = errorDescription
        case .loaded(let weatherData):
            self.statusLabel.isHidden = true
            self.weatherView.isHidden = false
            self.weatherView.configure(viewData: weatherData)
        }
    }
}
