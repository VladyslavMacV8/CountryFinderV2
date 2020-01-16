//
//  Router.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/12/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit

extension UIViewController {
    
    enum ViewType {
        case navigation
        case transport
        case present
        case push
        case close
        case pop
        case dismiss
    }
    
    func navigate(to routing: Routing, from type: ViewType) {
        switch type {
        case .push:
            pushViewController(with: routing)
        case .transport:
            transportViewController(with: routing)
        case .present:
            presentViewController(with: routing)
        case .pop:
            popCurrentVC()
        case .dismiss:
            dismissCurrentVC()
        default: break
        }
    }
}

private extension UIViewController {
    func pushViewController(with routing: Routing) {
        switch routing {
        case .openCountriesViewController(let value):
            let vc = CountriesViewController.instantiate(fromAppStoryboard: .Country)
            vc.title = value
            vc.viewModel.input.regionSubject.onNext(value)
            navigationController?.pushViewController(vc, animated: true)
        case .openCountryViewController(let value, let state):
            let vc = CountryViewController.instantiate(fromAppStoryboard: .Country)
            vc.state = state
            vc.viewModel.input.countrySubject.onNext(value)
            navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
    
    func transportViewController(with routing: Routing) {
        switch routing {
        default: break
        }
    }
    
    func presentViewController(with routing: Routing) {
        switch routing {
        default: break
        }
    }
    
    func popCurrentVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func dismissCurrentVC() {
        dismiss(animated: true, completion: nil)
    }
}
