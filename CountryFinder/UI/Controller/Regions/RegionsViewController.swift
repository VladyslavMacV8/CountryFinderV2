//
//  ViewController.swift
//  CountryFinder
//
//  Created by Vladyslav on 3/11/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit
import RxCocoa

final class RegionsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: RegionsViewModelType = RegionsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSignals()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.gray
        
        title = "Regions"
        
        tableView.backgroundColor = UIColor.clear
        tableView.register(cellType: RegionsTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
    }

    private func setupSignals() {
        viewModel.regionsSubject.bind(to: tableView.rx.items(cellIdentifier: RegionsTableViewCell.reuseIdentifier, cellType: RegionsTableViewCell.self)) { row, element, cell in
            cell.setupCell(element)
        }.disposed(by: viewModel.bag)
        
        tableView.rx.modelSelected(String.self).bind { [weak self] element in
            self?.navigate(to: .openCountriesViewController(element), from: .push)
        }.disposed(by: viewModel.bag)
    }
}

extension RegionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }
}
