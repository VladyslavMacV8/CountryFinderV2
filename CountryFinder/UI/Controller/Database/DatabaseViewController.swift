//
//  DatabaseViewController.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/14/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit
import RxSwift

final class DatabaseViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: CountriesViewModelType = CountriesViewModel(service: CountriesService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSignals()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshSignal), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    @objc private func refreshSignal() {
        viewModel.extra.fetchAllDataFromCoreData.subscribe().disposed(by: viewModel.extra.bag)
    }
    
    private func setupView() {
        title = "Database"
        
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
            self.navigate(to: .openCountryViewController(element, .database), from: .push)
        }.disposed(by: viewModel.extra.bag)
        
        viewModel.extra.fetchAllDataFromCoreData.subscribe().disposed(by: viewModel.extra.bag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DatabaseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
}

extension DatabaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
