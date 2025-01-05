//
//  Untitled.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import Foundation
import Combine

protocol SearchRouterProtocol {
    func navigateToResultDetailsPage(
        location: Location,
        locationDetailsRouterDelegate: LocationDetailsRouterDelegateProtocol
    )
}

// WIP: Unit tests
final class SearchViewModel: SearchViewModelProtocol {
    // TODO: This should be injected properly via some localisation service
    private static let emptySearchRequestMessage = "Start typing to search"
    
    var viewState: CurrentValueSubject<SearchViewState, Never> = CurrentValueSubject(
        .error(emptySearchRequestMessage)
    )
    
    private let router: SearchRouterProtocol
    private let searchService: LocationSearchServiceProtocol
    
    // TODO: We should introduce a local protocol for favorites. This will allow us to move FavoritesService into a separate module
    private let favoritesService: FavoritesServiceProtocol
    private var debounceTimer: Timer?
    
    init(
        router: SearchRouterProtocol,
        searchService: LocationSearchServiceProtocol,
        favoritesService: FavoritesServiceProtocol
    ) {
        self.router = router
        self.searchService = searchService
        self.favoritesService = favoritesService
        
        loadFavorites()
    }

    // TODO: There is no conflict resolving between initial favorites loading and active searches, sorry
    private func loadFavorites() {
        viewState.value = .loading
        
        Task { [weak self] in
            guard let self = self else { return }
            
            let favorites = await favoritesService.getFavorites()
            let newState: SearchViewState = {
                if favorites.count > 0 {
                    return .loaded(favorites)
                } else {
                    return .error(Self.emptySearchRequestMessage)
                }
            }()
            
            viewState.value = newState
        }
    }
    
    func searchQueryChanged(text: String?) {
        debounceTimer?.invalidate()
        
        guard let text = text, text.count > 1 else {
            loadFavorites()
            return
        }

        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            viewState.value = .loading
            Task { [weak self] in
                guard let self = self else { return }
                let result = await searchService.search(query: text)
                
                let newState: SearchViewState = {
                    switch result {
                    case .success(let searchResults):
                        return .loaded(searchResults)
                    case .failure(let error):
                        return .error(error.errorDescription)
                    }
                }()
                
                DispatchQueue.main.async { [weak self] in
                    self?.viewState.value = newState
                }
            }
        }
    }
    
    func searchResultSelected(Location: Location) {
        router.navigateToResultDetailsPage(
            location: Location,
            locationDetailsRouterDelegate: self
        )
    }
}

// WIP: This unnecessarily reloads the screen every time after dismissing the modal
extension SearchViewModel: LocationDetailsRouterDelegateProtocol {
    func didDismissLocationDetails() {
        loadFavorites()
    }
}
