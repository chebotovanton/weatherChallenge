//
//  ResultDetailsPageFactory.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

final class ResultDetailsPageFactory: ResultDetailsPageFactoryProtocol {
    func createResultDetailsController(searchResult: SearchResult) -> UIViewController {
        // WIP: Provide a proper controller here
        let viewController = UIViewController()
        viewController.title = searchResult.name
        viewController.view.backgroundColor = .white
        
        return viewController
    }
}
