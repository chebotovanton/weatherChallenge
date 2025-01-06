//
//  SearchViewModelTests.swift
//  WeatherChallengeTests
//
//  Created by Anton Chebotov on 05/01/2025.
//

import XCTest
import Combine
@testable import WeatherChallenge

// TODO: I haven't covered all classes with necessary tests, but hopefully this set is good enough example of injecting and mocking dependencies
final class SearchViewModelTests: XCTestCase {
    private var router: MockSearchRouter!
    private var searchService: MockLocationSearchService!
    private var favoritesService: MockFavoritesService!
    private var cancellables = Set<AnyCancellable>()
    private let expectationsTimeout: TimeInterval = 0.001

    override func setUp() {
        super.setUp()

        router = MockSearchRouter()
        searchService = MockLocationSearchService()
        favoritesService = MockFavoritesService()
    }

    func test_WhenSutCreated_ThenSutInLoadingState() {
        // When
        let sut = createSut()

        // Then
        XCTAssertEqual(sut.viewState.value, .loading)
    }

    // TODO: I'd be more than happy to discuss this further. Having expectations with a timeout is a slippery slope to get actual async code in unit tests, resulting in slow test runs
    // TODO: A better approach would be to consider the whole Task/async thread switching as a separate dependency, inject it and mock it for tests
    // TODO: Then we could do actual async code in production, and mocked sync execution in tests. This would allow us to avoid expectations
    func test_GivenSut_WhenEmptyFavoritesReturned_ThenSutInCorrectState() {
        // Given
        favoritesService.favoritesToReturn = []

        //When
        let sut = createSut()

        let expectation = XCTestExpectation(description: "Sut state after loading favorites")
        expectation.expectedFulfillmentCount = 1

        sut.viewState.sink { newValue in
            // TODO: Would be great to inject texts into the view model, and check we have the correct error message here
            if case .error(_) = newValue {
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: expectationsTimeout)
    }

    func test_GivenSut_WhenFavoritesReturned_ThenSutInCorrectState() {
        // Given
        favoritesService.favoritesToReturn = [.favorite]

        //When
        let sut = createSut()

        let expectation = XCTestExpectation(description: "Sut state after loading favorites")
        expectation.expectedFulfillmentCount = 1

        sut.viewState.sink { newValue in
            if case .loaded(let favorites) = newValue,
               favorites == [.favorite] {
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: expectationsTimeout)
    }

    func test_WhenSearchQueryChanged_ThenSutInLoadingState() {
        // Given
        let sut = createSut()

        // When
        sut.searchQueryChanged(text: "proper search query")

        // Then
        XCTAssertEqual(sut.viewState.value, .loading)
    }


    func test_WhenSearchQueryChanged_ThenSearchRequestSent() {
        // Given
        let sut = createSut()

        let expectation = XCTestExpectation(description: "Sending a search request")
        expectation.expectedFulfillmentCount = 1
        searchService.onSearch = { expectation.fulfill() }

        // When
        sut.searchQueryChanged(text: "proper search query")

        // Then
        wait(for: [expectation], timeout: expectationsTimeout)
        XCTAssertEqual(searchService.searchCallsCount, 1)
    }

    func test_WhenSearchQueryCleared_ThenNoSearchRequestSent() {
        // Given
        let sut = createSut()

        let expectation = XCTestExpectation(description: "Not sending a search request")
        expectation.isInverted = true
        searchService.onSearch = { expectation.fulfill() }

        // When
        sut.searchQueryChanged(text: "")

        // Then
        wait(for: [expectation], timeout: expectationsTimeout)
        XCTAssertEqual(searchService.searchCallsCount, 0)
    }

    func test_WhenSearchRequestFails_ThenSutInErrorState() {
        // Given
        let sut = createSut()

        let expectation = XCTestExpectation(description: "Sending a search request")
        expectation.expectedFulfillmentCount = 1
        searchService.onSearch = { expectation.fulfill() }
        searchService.errorToReturn = .emptyResponse

        // When
        sut.searchQueryChanged(text: "proper search query")

        // Then
        wait(for: [expectation], timeout: expectationsTimeout)
        guard case .error(_) = sut.viewState.value else {
            XCTFail("Incorrect viewState. Expected .error state, current state: \(sut.viewState.value)")
            return
        }
    }

    func test_WhenSearchRequestSuccessful_ThenSutInLoadedState() {
        // Given
        let sut = createSut()

        let expectation = XCTestExpectation(description: "Sending a search request")
        expectation.expectedFulfillmentCount = 1
        searchService.onSearch = { expectation.fulfill() }
        searchService.resultsToReturn = [.searchResult]

        // When
        sut.searchQueryChanged(text: "proper search query")

        // Then
        wait(for: [expectation], timeout: expectationsTimeout)
        guard case .loaded(let results) = sut.viewState.value else {
            XCTFail("Incorrect viewState. Expected .loaded state, current state: \(sut.viewState.value)")
            return
        }
        XCTAssertEqual(results, [.searchResult])
    }

    func test_GivenEmptySearchQuery_WhenLocationDetailsDismissed_ThenUpdatedFavoritesShown() {
        // Given
        let sut = createSut()
        favoritesService.favoritesToReturn = [.favorite]
        sut.searchQueryChanged(text: "")

        let expectation = XCTestExpectation(description: "Sut state after loading favorites")
        expectation.expectedFulfillmentCount = 1
        favoritesService.onGetFavorites = { expectation.fulfill() }

        // When
        favoritesService.favoritesToReturn = [.favorite, .favorite]
        sut.didDismissLocationDetails()

        // Then
        wait(for: [expectation], timeout: expectationsTimeout)
        guard case .loaded(let results) = sut.viewState.value else {
            XCTFail("Incorrect viewState. Expected .loaded state, current state: \(sut.viewState.value)")
            return
        }
        XCTAssertEqual(results, [.favorite, .favorite])
    }

    func test_GivenNonEmptySearchQuery_WhenLocationDetailsDismissed_ThenSearchResultsShown() {
        // Given
        let sut = createSut()
        favoritesService.favoritesToReturn = [.favorite]
        searchService.resultsToReturn = [.empty, .searchResult]

        let favExpectation = XCTestExpectation(description: "Loading favorites")
        favExpectation.expectedFulfillmentCount = 1
        favoritesService.onGetFavorites = { favExpectation.fulfill() }
        wait(for: [favExpectation], timeout: expectationsTimeout)

        let searchExpectation = XCTestExpectation(description: "Making a search request")
        searchExpectation.expectedFulfillmentCount = 1
        searchService.onSearch = { searchExpectation.fulfill() }
        sut.searchQueryChanged(text: "proper search query")
        wait(for: [searchExpectation], timeout: expectationsTimeout)

        // When
        favoritesService.favoritesToReturn = [.favorite, .favorite]
        sut.didDismissLocationDetails()

        // Then
        guard case .loaded(let results) = sut.viewState.value else {
            XCTFail("Incorrect viewState. Expected .loaded state, current state: \(sut.viewState.value)")
            return
        }
        XCTAssertEqual(results, [.empty, .searchResult])
    }

    func test_WhenLocationSelected_ThenLocationDetailsShown() {
        // Given
        let sut = createSut()

        // When
        sut.searchResultSelected(Location: .empty)

        // Then
        XCTAssertEqual(router.callsCount, 1)
        XCTAssertEqual(router.lastLocation, .empty)
    }

    private func createSut() -> SearchViewModel {
        return SearchViewModel(
            searchDebounceDelay: 0,
            router: router,
            searchService: searchService,
            favoritesService: favoritesService
        )
    }
}

private extension Location {
    static var empty: Self {
        return Location(name: "Name", country: "", state: "", lat: 0, lon: 0)
    }

    static var favorite: Self {
        return Location(name: "Favorite", country: "", state: "", lat: 0, lon: 0)
    }

    static var searchResult: Self {
        return Location(name: "SearchResult", country: "", state: "", lat: 0, lon: 0)
    }
}

// TODO: Could use Sourcery for this
private final class MockSearchRouter: SearchRouterProtocol {
    var callsCount = 0
    var lastLocation: Location?

    func navigateToResultDetailsPage(
        location: Location,
        locationDetailsRouterDelegate: LocationDetailsRouterDelegateProtocol
    ) {
        callsCount += 1
        lastLocation = location
    }
}

private final class MockLocationSearchService: LocationSearchServiceProtocol {
    var searchCallsCount = 0
    var resultsToReturn: [Location]?
    var errorToReturn: LocationSearchError?
    var onSearch: () -> Void = {}

    func search(query: String) async -> Result<[Location], LocationSearchError> {
        searchCallsCount += 1
        onSearch()
        if let errorToReturn = errorToReturn {
            return .failure(errorToReturn)
        } else {
            return .success(resultsToReturn ?? [])
        }
    }
}

private final class MockFavoritesService: FavoritesServiceProtocol {
    var favoritesToReturn: [Location] = []
    var getFavoritesCallsCount = 0
    var onGetFavorites: () -> Void = {}

    func getFavorites() async -> [Location] {
        getFavoritesCallsCount += 1
        onGetFavorites()
        return favoritesToReturn
    }
    
    func hasFavorite(location: WeatherChallenge.Location) async -> Bool {
        return false
    }
    
    func addFavorite(location: WeatherChallenge.Location) async { }
    func removeFavorite(location: WeatherChallenge.Location) async { }
}

// WIP: Add more comments to Readme.md
// WIP: Test the app manually after fixing all the tests
