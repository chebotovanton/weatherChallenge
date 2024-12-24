//
//  LocationDetailsRouter.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

final class LocationDetailsRouter: LocationDetailsRouterProtocol {
    var presentedViewController: UIViewController?
        
    func goBack() {
        presentedViewController?.dismiss(animated: true)
    }
}
