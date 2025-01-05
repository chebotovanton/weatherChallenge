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

final class LocationDetailsRouter: NSObject, LocationDetailsRouterProtocol {
    var presentedViewController: UIViewController?
    weak var delegate: LocationDetailsRouterDelegateProtocol?
    
    init(
        delegate: LocationDetailsRouterDelegateProtocol
    ) {
        self.delegate = delegate
    }

    func setPresentingViewController(vc: UIViewController) {
        vc.presentedViewController?.presentationController?.delegate = self
    }

    func goBack() {
        presentedViewController?.dismiss(animated: true) { [weak self] in
            self?.delegate?.didDismissLocationDetails()
        }
    }
}

extension LocationDetailsRouter: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.didDismissLocationDetails()
    }
}
