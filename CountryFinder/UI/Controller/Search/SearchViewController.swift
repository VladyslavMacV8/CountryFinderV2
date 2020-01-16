//
//  SearchViewController.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/14/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit
import RxSwift

final class SearchViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var textField = UITextField()
    let viewModel: CountriesViewModelType = CountriesViewModel(service: CountriesService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSignals()
    }
    
    private func setupView() {
        textField.frame.size = CGSize(width: view.frame.width * 0.8, height: 30)
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.placeholder = "Search"
        navigationItem.titleView = textField
        
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        tableView.register(cellType: CountriesTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
    }
    
    private func setupSignals() {
        viewModel.output.countriesDriver.drive(tableView.rx.items(cellIdentifier: CountriesTableViewCell.reuseIdentifier, cellType: CountriesTableViewCell.self)) { row, element, cell in
            cell.setupCell(element)
        }.disposed(by: viewModel.extra.bag)
        
        tableView.rx.modelSelected(CountryEntity.self).bind { [weak self] element in
            guard let `self` = self else { return }
            self.navigate(to: .openCountryViewController(element, .search), from: .push)
        }.disposed(by: viewModel.extra.bag)

        textField.rx.text.orEmpty.throttle(1.5, scheduler: MainScheduler()).bind(to: viewModel.input.searchObserver).disposed(by: viewModel.extra.bag)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

