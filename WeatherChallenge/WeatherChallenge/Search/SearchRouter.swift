//
//  SearchRouter.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

protocol ResultDetailsPageFactoryProtocol {
    func createResultDetailsController(searchResult: SearchResult) -> UIViewController
}

// WIP: Add unit tests
final class SearchRouter: SearchRouterProtocol {
    private let navigationController: UINavigationController
    private let resultDetailsPageFactory: ResultDetailsPageFactoryProtocol
    
    init(
        navigationController: UINavigationController,
        resultDetailsPageFactory: ResultDetailsPageFactoryProtocol
    ) {
        self.navigationController = navigationController
        self.resultDetailsPageFactory = resultDetailsPageFactory
    }
    
    func navigateToResultDetailsPage(searchResult: SearchResult) {
        let viewController = resultDetailsPageFactory.createResultDetailsController(searchResult: searchResult)
        navigationController.pushViewController(viewController, animated: true)
    }
}
