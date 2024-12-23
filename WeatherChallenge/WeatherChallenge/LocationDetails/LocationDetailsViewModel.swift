//
//  LocationDetailsViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

final class LocationDetailsViewModel: LocationDetailsViewModelProtocol {
    var viewData: Observable<LocationDetailsViewData> = Observable(
        LocationDetailsViewData(
            currentWeatherData: .loading,
            forecastData: .loading
        )
    )
    
    private let location: SearchResult
    private let weatherLoadingService: WeatherLoadingServiceProtocol
    
    init(
        location: SearchResult,
        weatherLoadingService: WeatherLoadingServiceProtocol
    ) {
        self.location = location
        self.weatherLoadingService = weatherLoadingService
    }
    
    func startLoadingWeatherData() {
        // WIP: Handle this similarly to the other view model
        Task { [weak self] in
            self.weatherLoadingService.currentWeather(location: location)
        }
    }
}
