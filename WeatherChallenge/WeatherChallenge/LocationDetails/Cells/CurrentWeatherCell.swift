//
//  CurrentWeatherCell.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

struct CurrentWeatherData: Decodable {
    struct Weather: Decodable {
        let main: String
        let description: String
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
    var viewData: Observable<WeatherDataContainer<CurrentWeatherData>> { get }
    
    func startLoadingData()
}

final class CurrentWeatherCell: UITableViewCell {
    private var viewModel: CurrentWeatherCellViewModelProtocol?
    private let statusLabel = UILabel()
    private let weatherView = CurrentWeatherView()
    
    func configure(viewModel: CurrentWeatherCellViewModelProtocol) {
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
        selectionStyle = .none
        
        addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        statusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(weatherView)
        weatherView.pinToSuperviewEdges()
    }
    
    private func updateState(newState: WeatherDataContainer<CurrentWeatherData>) {
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

private class CurrentWeatherView: UIView {
    private let mainLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let tempLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(
            arrangedSubviews: [
                mainLabel,
                descriptionLabel,
                tempLabel
            ]
        )
        addSubview(stackView)
        stackView.pinToSuperviewEdges()
        
        stackView.axis = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewData: CurrentWeatherData) {
        self.mainLabel.text = viewData.weather.first?.main ?? "Undefined"
        self.descriptionLabel.text = viewData.weather.first?.description ?? "Undefined"
        self.tempLabel.text = String(viewData.main.temp)
    }
}

// WIP: Rain/Sun
