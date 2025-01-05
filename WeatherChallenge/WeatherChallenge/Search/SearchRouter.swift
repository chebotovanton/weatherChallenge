//
//  SearchRouter.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

protocol ResultDetailsPageFactoryProtocol {
    func createResultDetailsController(
        location: Location,
        locationDetailsRouterDelegate: LocationDetailsRouterDelegateProtocol
    ) -> (UIViewController, LocationDetailsRouterProtocol)
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
    
    func navigateToResultDetailsPage(
        location: Location,
        locationDetailsRouterDelegate: LocationDetailsRouterDelegateProtocol
    ) {
        let (viewController, router) = resultDetailsPageFactory.createResultDetailsController(
            location: location,
            locationDetailsRouterDelegate: locationDetailsRouterDelegate
        )
        let navVC = UINavigationController(rootViewController: viewController)
        navigationController.present(navVC, animated: true)
        router.setPresentingViewController(vc: navigationController)
    }
}
