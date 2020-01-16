//
//  CountriesViewModel.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CountriesViewModelInput: class {
    var regionSubject: BehaviorSubject<String> { get }
    var searchObserver: AnyObserver<String> { get }
}

protocol CountriesViewModelOutput: class {
    var countriesDriver: Driver<[CountryEntity]> { get }
}

protocol CountriesViewModelExtra: class {
    var bag: DisposeBag { get }
    var fetchAllDataFromCoreData: Observable<Void> { get }
}

protocol CountriesViewModelType: class {
    var input: CountriesViewModelInput { get }
    var output: CountriesViewModelOutput { get }
    var extra: CountriesViewModelExtra { get }
}

final class CountriesViewModel: GeneralViewModel, CountriesViewModelType, CountriesViewModelInput, CountriesViewModelOutput, CountriesViewModelExtra {
    
    let regionSubject = BehaviorSubject<String>(value: "")
    let searchObserver: AnyObserver<String>
    let countriesDriver: Driver<[CountryEntity]>
    let bag = DisposeBag()
    
    var input: CountriesViewModelInput { return self }
    var output: CountriesViewModelOutput { return self }
    var extra: CountriesViewModelExtra { return self }
    
    private let searchSubject = PublishSubject<String>()
    private let countriesSubject = PublishSubject<[CountryEntity]>()
    
    init(service: CountriesServiceType) {
        
        searchObserver = searchSubject.asObserver()
        countriesDriver = countriesSubject.asDriver(onErrorJustReturn: [])
        
        super.init()
        
        regionSubject.flatMapLatest { region in
            return service.getRegionData(region).materialize()
            }.subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let element):
                    self?.countriesSubject.onNext(element)
                case .error(let error):
                    debugPrint(error)
                case .completed: break
                }
            }).disposed(by: bag)

        searchSubject.flatMapLatest { value in
            return service.getSearchData(value).materialize()
            }.subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let element):
                    self?.countriesSubject.onNext(element)
                case .error(let error):
                    print(error)
                    self?.countriesSubject.onNext([])
                case .completed: break
                }
            }).disposed(by: bag)
    }
    
    var fetchAllDataFromCoreData: Observable<Void> {
        return Observable.create { observer -> Disposable in
            var countries = [CountryEntity]()
            self.manager.fetchObjects { [weak self] entities in
                entities.forEach { entity in
                    
                    var currencies = [CurrencyCountryEntity]()
                    entity.currencies.forEach { currency in
                        currencies.append(CurrencyCountryEntity(name: currency.name))
                    }
                    
                    var languages = [LanguageCountryEntity]()
                    entity.languages.forEach { language in
                        languages.append(LanguageCountryEntity(name: language.name))
                    }
                    
                    countries.append(CountryEntity(name: entity.name, nativeName: entity.nativeName, alphaCode: entity.alphaCode, region: entity.region,
                                                   coordinates: entity.coordinates, borders: entity.borders, currencies: currencies, languages: languages))
                    
                }
                
                self?.countriesSubject.onNext(countries)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
