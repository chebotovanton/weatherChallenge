//
//  LocationDetailsRouter.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

protocol LocationDetailsRouterDelegateProtocol: AnyObject {
    func didDismissLocationDetails()
}

final class LocationDetailsRouter: LocationDetailsRouterProtocol {
    var presentedViewController: UIViewController?
    weak var delegate: LocationDetailsRouterDelegateProtocol?
    
    init(
        delegate: LocationDetailsRouterDelegateProtocol
    ) {
        self.delegate = delegate
    }
        
    func goBack() {
        presentedViewController?.dismiss(animated: true) { [weak self] in
            self?.delegate?.didDismissLocationDetails()
        }
    }
}
