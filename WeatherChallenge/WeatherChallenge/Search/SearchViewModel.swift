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
    var searchResults: Observable<[SearchResult]> = Observable(
        [
            SearchResult(name: "one"),
            SearchResult(name: "two")
        ]
    )
    
    private let router: SearchRouterProtocol
    
    init(
        router: SearchRouterProtocol
    ) {
        self.router = router
    }
    
    func searchQueryChanged(text: String) {
        // WIP: Debounce calls here
        print(text)
        // WIP: How to actually find locations?
    }
    
    func searchResultSelected(searchResult: SearchResult) {
        router.navigateToResultDetailsPage(searchResult: searchResult)
    }
}
