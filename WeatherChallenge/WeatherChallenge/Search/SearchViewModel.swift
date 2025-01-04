//
//  Untitled.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import Foundation

protocol SearchRouterProtocol {
    func navigateToResultDetailsPage(Location: Location)
}

// WIP: Unit tests
final class SearchViewModel: SearchViewModelProtocol {
    var viewState: Observable<SearchViewState> = Observable(
        .error("Start typing to search")
    )
    
    private let router: SearchRouterProtocol
    private let searchService: LocationSearchServiceProtocol
    private var debounceTimer: Timer?

    
    init(
        router: SearchRouterProtocol,
        searchService: LocationSearchServiceProtocol
    ) {
        self.router = router
        self.searchService = searchService
    }
    
    func searchQueryChanged(text: String?) {
        debounceTimer?.invalidate()
        
        guard let text = text, text.count > 1 else { return }

        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            self.viewState.value = .loading
            Task { [weak self] in
                guard let self = self else { return }
                let result = await self.searchService.search(query: text)
                
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
        router.navigateToResultDetailsPage(Location: Location)
    }
}
