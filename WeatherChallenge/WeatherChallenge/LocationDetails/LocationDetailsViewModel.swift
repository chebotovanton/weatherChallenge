//
//  LocationDetailsViewModel.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import Foundation
import Combine

protocol LocationDetailsRouterProtocol {
    func goBack()
}

final class LocationDetailsViewModel: LocationDetailsViewModelProtocol {
    var favoriteButtonTitle: CurrentValueSubject<String, Never> = CurrentValueSubject("")

    var viewData: LocationDetailsViewData
    
    private let location: Location
    private let router: LocationDetailsRouterProtocol
    private let favoritesService: FavoritesServiceProtocol
    
    init(
        location: Location,
        weatherItems: [WeatherItemProtocol],
        router: LocationDetailsRouterProtocol,
        favoritesService: FavoritesServiceProtocol
    ) {
        self.location = location
        self.viewData = LocationDetailsViewData(weatherItems: weatherItems)
        self.router = router
        self.favoritesService = favoritesService
        
        updateFavoriteStatus()
    }
    
    func viewDidAppear() {
        // TODO: track analytics here or do any additional setup
    }
    
    func close() {
        router.goBack()
    }
    
    func favoriteButtonClicked() {
        Task { [weak self] in
            guard let self = self else { return }
            let isFavorite = await favoritesService.hasFavorite(location: location)
            if isFavorite {
                await favoritesService.removeFavorite(location: location)
            } else {
                await favoritesService.addFavorite(location: location)
            }
            
            updateFavoriteStatus()
        }
    }
    
    private func updateFavoriteStatus() {
        Task { [weak self] in
            guard let self = self else { return }
            let isFavorite = await favoritesService.hasFavorite(location: location)
            let newFavoriteButtonTitle = isFavorite ? "Remove" : "Add"
         
            favoriteButtonTitle.value = newFavoriteButtonTitle
        }
    }
}
