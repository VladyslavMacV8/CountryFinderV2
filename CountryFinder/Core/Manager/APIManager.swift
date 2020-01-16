//
//  APIManager.swift
//  CountryFinder
//
//  Created by Vladyslav on 3/11/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import Moya
import RxSwift

private func JSONResponseDataFormatter(data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data as Data, options: [])
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData as Data
    } catch {
        return data
    }
}

public enum ApiManager {
    case byName(String)
    case byRegion(String)
    case byCode(String)
    case byCodes(String)
}

extension ApiManager: TargetType {
    
    public var baseURL: URL {
        guard let url = URL(string: Constants.baseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    public var headers: [String : String]? {
        var httpHeaders = [String: String]()
        httpHeaders["Content-type"] = "application/json"
        return httpHeaders
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var path: String {
        switch self {
        case .byName(let title):
            return "name/\(title)"
        case .byRegion(let title):
            return "region/\(title)"
        case .byCode(let code):
            return "alpha/\(code)"
        case .byCodes:
            return "alpha"
        }
    }
    
    public var task: Task {
        switch self {
        case .byName, .byRegion, .byCode:
            return .requestPlain
        case .byCodes(let code):
            return .requestParameters(parameters: ["codes": code], encoding: URLEncoding.queryString)
        }
    }
}

private struct MoyaManager {
    static let networkProvider = MoyaProvider<ApiManager>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
}

struct NetworkProcessing {
    static func make<T: Codable>(with token: ApiManager) -> Observable<[T]> {
        return Observable.create { observer in
            MoyaManager.networkProvider.rx.request(token, callbackQueue: Queues.workQueue).subscribe(onSuccess: { response in
                    do {
                        let entity = try JSONDecoder().decode([T].self, from: response.data)
                        observer.onNext(entity)
                    } catch {
                        observer.onError(error)
                    }
                }, onError: { error in
                    observer.onError(error)
                })
            }.subscribeOn(Queues.backgroundQueue)
    }
}
