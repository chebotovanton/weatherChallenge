//
//  LocationDetailsViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import Foundation

protocol LocationDetailsRouterProtocol {
    func goBack()
}

final class LocationDetailsViewModel: LocationDetailsViewModelProtocol {
    var viewData: LocationDetailsViewData
    
    private let location: Location
    private let router: LocationDetailsRouterProtocol
    
    init(
        location: Location,
        weatherItems: [WeatherItemProtocol],
        router: LocationDetailsRouterProtocol
    ) {
        self.location = location
        self.viewData = LocationDetailsViewData(weatherItems: weatherItems)
        self.router = router
    }
    
    func viewDidAppear() {
        // TODO: track analytics here or do any additional setup
    }
    
    func close() {
        router.goBack()
    }
}
