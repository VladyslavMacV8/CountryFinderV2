//
//  CountriesViewController.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit
import RxSwift

enum CountriesControllerState {
    case search
    case database
    case standart
}

final class CountriesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    let viewModel: CountriesViewModelType = CountriesViewModel(service: CountriesService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSignals()
    }

    private func setupView() {
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        tableView.register(cellType: CountriesTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
    }
    
    private func setupSignals() {
        viewModel.output.countriesDriver.drive(tableView.rx.items(cellIdentifier: CountriesTableViewCell.reuseIdentifier, cellType: CountriesTableViewCell.self)) { _, element, cell in
            cell.setupCell(element)
        }.disposed(by: viewModel.extra.bag)

        tableView.rx.modelSelected(CountryEntity.self).bind { [weak self] element in
            guard let `self` = self else { return }
            self.navigate(to: .openCountryViewController(element, .standart), from: .push)
        }.disposed(by: viewModel.extra.bag)
    }
}

extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
}
