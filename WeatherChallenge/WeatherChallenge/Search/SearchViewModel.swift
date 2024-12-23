//
//  Untitled.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

final class SearchViewModel: SearchViewModelProtocol {
    var searchResults: [SearchResult] = [
        SearchResult(name: "one"),
        SearchResult(name: "two")
    ]
    
    func searchQueryChanged(text: String) {
        // WIP: Debounce calls here
        print(text)
    }
}
