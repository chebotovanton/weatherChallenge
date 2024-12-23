//
//  LocationDetailsViewController.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

protocol LocationDetailsViewModelProtocol {
    var viewData: Observable<LocationDetailsViewData> { get }
    
    func startLoadingWeatherData()
}

enum WeatherDataContainer<T> {
    case loading
    case error(String)
    case loaded(T)
}

struct CurrentWeatherData: Decodable {
    let description: String
}

struct ForecastItem {
    
}

struct ForecastData {
    let days: [ForecastItem]
}

struct LocationDetailsViewData {
    let currentWeatherData: WeatherDataContainer<CurrentWeatherData>
    let forecastData: WeatherDataContainer<ForecastData>
}

final class LocationDetailsViewController: UIViewController {
    
    private let viewModel: LocationDetailsViewModelProtocol
    
    private let tableView = UITableView()
    private let currentWeatherCellIdentifier = "currentWeatherCellIdentifier"
    private let forecastCellIdentifier = "forecastCellIdentifier"
    
    init(viewModel: LocationDetailsViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        viewModel.startLoadingWeatherData()
    }
    
    private func setupTableView() {
        // WIP: Introduce different cells
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: currentWeatherCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: forecastCellIdentifier)
        
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

extension LocationDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // WIP: I'm not happy with the explicit indexing
        if section == 0 {
            return 1
        } else {
            // WIP: Provide a proper value here
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: currentWeatherCellIdentifier, for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: forecastCellIdentifier, for: indexPath)
            return cell
        }
    }
}

// WIP: Weather now
// WIP: 5 days forecast
// WIP: Disable cell selection
