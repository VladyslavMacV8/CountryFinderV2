//
//  CountryViewModel.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CountryViewModelInput: class {
    var countrySubject: BehaviorSubject<CountryEntity?> { get }
}

protocol CountryViewModelOutput: class {
    var countriesDriver: Driver<[CountryEntity]> { get }
}

protocol CountryViewModelExtra: class {
    var bag: DisposeBag { get }
    
    func checkCountryExistance(for nativeName: String) -> Observable<Bool>
    func saveCountry(for country: CountryEntity) -> Observable<Void>
    func deleteCountry(for nativeName: String) -> Observable<Void>
}

protocol CountryViewModelType: class {
    var input: CountryViewModelInput { get }
    var output: CountryViewModelOutput { get }
    var extra: CountryViewModelExtra { get }
}

final class CountryViewModel: GeneralViewModel, CountryViewModelType, CountryViewModelInput, CountryViewModelOutput, CountryViewModelExtra {
    
    let countrySubject = BehaviorSubject<CountryEntity?>(value: nil)
    let countriesDriver: Driver<[CountryEntity]>
    let bag = DisposeBag()
    
    var input: CountryViewModelInput { return self }
    var output: CountryViewModelOutput { return self }
    var extra: CountryViewModelExtra { return self }
    
    private let countriesSubject = PublishSubject<[CountryEntity]>()
    
    init(service: CountryServiceType) {
        
        countriesDriver = countriesSubject.asDriver(onErrorJustReturn: [])
        
        super.init()
        
        countrySubject.subscribe(onNext: { [weak self] value in
            guard let country = value, !country.borders.isEmpty else { return }
            self?.getBorderCountries(with: service)
        }).disposed(by: bag)
    }
    
    func checkCountryExistance(for nativeName: String) -> Observable<Bool> {
        return Observable.create { observer -> Disposable in
            observer.onNext(self.manager.isObjectExists(for: nativeName))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func saveCountry(for country: CountryEntity) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            observer.onNext(self.manager.saveObject(country))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func deleteCountry(for nativeName: String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            observer.onNext(self.manager.deleteObject(for: nativeName))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    private func getBorderCountries(with service: CountryServiceType) {
        countrySubject.flatMapLatest { value in
            return service.getBorderData(value?.borders.joined(separator: ";") ?? "").materialize()
        }.subscribe(onNext: { [weak self] event in
            switch event {
            case .next(let element):
                self?.countriesSubject.onNext(element)
            case .error(let error):
                debugPrint(error)
            case .completed: break
            }
        }).disposed(by: bag)
    }
}
