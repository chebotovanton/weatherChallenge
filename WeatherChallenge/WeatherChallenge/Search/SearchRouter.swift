//
//  SearchRouter.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

final class SearchRouter: SearchRouterProtocol {
    private let navigationController: UINavigationController
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    func navigateToResultDetailsPage() {
        // WIP: Destination controller should be provided by the users of the router?
        let viewController = UIViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
