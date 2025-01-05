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
    var viewData: CurrentValueSubject<WeatherDataContainer<CurrentWeatherData>, Never> { get }

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

// TODO: We can make this view public and reuse it outside of UITableView if needed
private final class CurrentWeatherView: UIView {
    
    private final class HighLowView: UIView {
        // TODO: Would be nice to introduce some styling-ability by injecting styles into every view and combining those styles for the higher-level views
        private let highLabel = UILabel()
        private let lowLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            let stackView = UIStackView(
                arrangedSubviews: [
                    highLabel,
                    // WIP: Add some spacer here
                    lowLabel
                ]
            )
            addSubview(stackView)
            stackView.pinToSuperviewEdges()
            stackView.axis = .horizontal
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(viewData: CurrentWeatherData.Main) {
            highLabel.text = String(viewData.temp_max)
            lowLabel.text = String(viewData.temp_min)
        }
    }
    
    private let mainLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let tempLabel = UILabel()
    private let highLowView = HighLowView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(
            arrangedSubviews: [
                mainLabel,
                descriptionLabel,
                tempLabel,
                highLowView
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
        mainLabel.text = viewData.weather.first?.main ?? "Undefined"
        descriptionLabel.text = viewData.weather.first?.description ?? "Undefined"
        tempLabel.text = String(viewData.main.temp)
        highLowView.configure(viewData: viewData.main)
    }
}
