//
//  LocationDetailsViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import Foundation

final class LocationDetailsViewModel: LocationDetailsViewModelProtocol {
    var viewData: LocationDetailsViewData
    
    private let location: SearchResult
    
    init(
        location: SearchResult,
        weatherItems: [WeatherItemProtocol]
    ) {
        self.location = location
        self.viewData = LocationDetailsViewData(weatherItems: weatherItems)
    }
    
    func viewDidAppear() {
        // TODO: track analytics here or do any additional setup
    }
}
