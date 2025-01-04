//
//  FavoritesService.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 04/01/2025.
//

import Foundation

protocol FavoritesServiceProtocol {
    // TODO: async added to support any potential future Favorite storage implementation which may be asynchronous
    func getFavorites() async -> [Location]
    func addFavorite(location: Location) async
    func removeFavorite(location: Location) async
}

final class FavoritesService: FavoritesServiceProtocol {
    
    private let userDefaultsKey = "favoriteLocations_userDefaultsKey"
    
    // TODO: in real world I'd hide the userDefaults behind a custom protocol for testability
    private let userDefaults: UserDefaults
    
    init(
        userDefaults: UserDefaults
    ) {
        self.userDefaults = userDefaults
    }
    
    func getFavorites() async -> [Location] {
        userDefaults.array(forKey: userDefaultsKey) as? [Location] ?? []
    }
    
    func addFavorite(location: Location) async {
        var existingFavorites = userDefaults.array(forKey: userDefaultsKey) as? [Location] ?? []
        existingFavorites.append(location)
        userDefaults.set(existingFavorites, forKey: userDefaultsKey)
    }
    
    func removeFavorite(location: Location) async {
        var existingFavorites = userDefaults.array(forKey: userDefaultsKey) as? [Location] ?? []
        existingFavorites.removeAll { $0 == location }
        userDefaults.set(existingFavorites, forKey: userDefaultsKey)
    }
}
