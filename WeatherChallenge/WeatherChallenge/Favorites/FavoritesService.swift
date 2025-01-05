//
//  FavoritesService.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 04/01/2025.
//

import Foundation

protocol FavoritesServiceProtocol {
    // TODO: async added to support any potential future Favorite storage implementation which may be more complex than UserDefaults
    func getFavorites() async -> [Location]
    func hasFavorite(location: Location) async -> Bool
    func addFavorite(location: Location) async
    func removeFavorite(location: Location) async
}

final class FavoritesService: FavoritesServiceProtocol {
    let userDefaultsKey = "favoriteLocations_userDefaultsKey"
    
    // TODO: in real world I'd hide the userDefaults behind a custom protocol for testability
    private let userDefaults: UserDefaults
    
    init(
        userDefaults: UserDefaults
    ) {
        self.userDefaults = userDefaults
    }
    
    func getFavorites() async -> [Location] {
        guard let data = userDefaults.object(forKey: userDefaultsKey) as? Data,
              let favorites = try? JSONDecoder().decode([Location].self, from: data) else { return [] }
        return favorites
    }
    
    func hasFavorite(location: Location) async -> Bool {
        let existingFavorites = await getFavorites()
        return existingFavorites.contains { $0 == location }
    }
    
    func addFavorite(location: Location) async {
        var existingFavorites = await getFavorites()
        existingFavorites.append(location)
        await saveFavorites(locations: existingFavorites)
    }
    
    func removeFavorite(location: Location) async {
        var existingFavorites = await getFavorites()
        existingFavorites.removeAll { $0 == location }
        await saveFavorites(locations: existingFavorites)
    }
        
    private func saveFavorites(locations: [Location]) async {
        if let encoded = try? JSONEncoder().encode(locations) {
            userDefaults.set(encoded, forKey: userDefaultsKey)
        }
    }
}
