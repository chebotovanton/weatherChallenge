//
//  Untitled.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

protocol SearchRouterProtocol {
    func navigateToResultDetailsPage(searchResult: SearchResult)
}

// WIP: Unit tests
final class SearchViewModel: SearchViewModelProtocol {
    var viewState: Observable<SearchViewState> = Observable(
        .loaded(
            [
                SearchResult(name: "one"),
                SearchResult(name: "two")
            ]
        )
    )
    
    private let router: SearchRouterProtocol
    private let searchService: LocationSearchServiceProtocol
    
    init(
        router: SearchRouterProtocol,
        searchService: LocationSearchServiceProtocol
    ) {
        self.router = router
        self.searchService = searchService
    }
    
    func searchQueryChanged(text: String) {
        // WIP: Debounce calls here
        self.viewState.value = .loading
        searchService.search(query: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let searchResults):
                self.viewState.value = .loaded(searchResults)
            case .failure(let error):
                self.viewState.value = .error(error.errorDescription)
            }
        }
    }
    
    func searchResultSelected(searchResult: SearchResult) {
        router.navigateToResultDetailsPage(searchResult: searchResult)
    }
}
