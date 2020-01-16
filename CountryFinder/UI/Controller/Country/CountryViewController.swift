//
//  CountryViewController.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit
import RxSwift

final class CountryViewController: UIViewController {
    
    @IBOutlet private weak var placeholderView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    
    private let countryView = CountryView.loadFromNib()
    private let actionButton = UIButton(type: .custom)
    
    let viewModel: CountryViewModelType = CountryViewModel(service: CountryService())
    var state: CountriesControllerState = .standart
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
    }
    
    private func prepareData() {
        guard let value = try? viewModel.input.countrySubject.value() else { return }
        setupViews(country: value)
        setupSignals(country: value)
    }
    
    private func setupViews(country: CountryEntity) {
        title = country.name
        
        switch state {
        case .standart, .search:
            actionButton.setTitle("Save", for: .normal)
        case .database:
            actionButton.setTitle("Delete", for: .normal)
        }
        actionButton.setTitleColor(UIColor.blue, for: .normal)
        actionButton.setTitleColor(UIColor.gray, for: .disabled)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        
        placeholderView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        placeholderView.addSubview(countryView)
        countryView.configData(country)
        countryView.translatesAutoresizingMaskIntoConstraints = false
        countryView.topAnchor.constraint(equalTo: placeholderView.topAnchor).isActive = true
        countryView.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor).isActive = true
        countryView.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor).isActive = true
        countryView.bottomAnchor.constraint(equalTo: placeholderView.bottomAnchor).isActive = true
        
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        collectionView.register(cellType: CountryCollectionViewCell.self)
        collectionView.delegate = self
    }
    
    private func setupSignals(country: CountryEntity) {
        viewModel.output.countriesDriver.drive(onNext: { value in
            guard !value.isEmpty else { return }
            self.collectionViewHeight.constant = self.view.frame.height / 5
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        }).disposed(by: viewModel.extra.bag)
        
        viewModel.output.countriesDriver.drive(collectionView.rx.items(cellIdentifier: CountryCollectionViewCell.reuseIdentifier, cellType: CountryCollectionViewCell.self)) { _, element, cell in
            cell.setupCell(element)
        }.disposed(by: viewModel.extra.bag)

        switch state {
        case .standart, .search:
            viewModel.extra.checkCountryExistance(for: country.nativeName).bind(to: actionButton.rx.isEnabled).disposed(by: viewModel.extra.bag)
            actionButton.rx.tap.bind { [weak self] in
                guard let `self` = self else { return }
                self.viewModel.extra.saveCountry(for: country).subscribe().disposed(by: self.viewModel.extra.bag)
                self.actionButton.isEnabled = false
            }.disposed(by: viewModel.extra.bag)
        case .database:
            actionButton.rx.tap.bind { [weak self] in
                guard let `self` = self else { return }
                self.viewModel.extra.deleteCountry(for: country.nativeName).subscribe().disposed(by: self.viewModel.extra.bag)
                self.navigate(to: .pop, from: .pop)
            }.disposed(by: viewModel.extra.bag)
        }
    }
}

extension CountryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.height * 0.15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}
