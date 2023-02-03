//
//  StationNetwork.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import Foundation
import RxSwift

struct NetworkProvider {
    private let session: URLSessionProtocol
    private let disposeBag = DisposeBag()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Codable>(stationType: Int, api: Gettable, decodingType: T.Type) -> Observable<T> {
        return Observable.create { emitter in
            guard let task = dataTask(stationType: stationType, api: api, emitter: emitter) else {
                return Disposables.create()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func dataTask<T: Codable>(stationType: Int, api: APIProtocol, emitter: AnyObserver<T>) -> URLSessionDataTaskProtocol? {
        guard let urlRequest = URLRequest(api: api) else {
            emitter.onError(NetworkError.invalidURL)
            return nil
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, _ in
            let successStatusCode = 200..<300
            guard let httpResponse = response as? HTTPURLResponse,
                  successStatusCode.contains(httpResponse.statusCode) else {
                emitter.onError(NetworkError.statusCodeError)
                return
            }
            
            switch api {
            case is Gettable:
                if let data = data {
                    switch stationType {
                    case 1:
                        if let data = data as? T {
                            emitter.onNext(data)
                        }
                    default:
                        guard let decodedData = JSONParser<T>().decode(from: data) else {
                            emitter.onError(JSONParserError.decodingFail)
                            return
                        }
                        
                        emitter.onNext(decodedData)
                    }
                }
            
            default:
                return
            }
            
            emitter.onCompleted()
        }
        
        return task
    }
    
    public func getStationList() -> Single<Result<StationList, NetworkError>> {
        return self.fetchData(stationType: 0, api: StationListAPI(), decodingType: StationList.self)
            .map { data in
                return .success(data)
            }
            .catch { _ in
                return .just(Result.failure(NetworkError.networkError))
            }
            .asSingle()
    }
    
    func getJsonToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        guard let url = URL(string: urlString) else {
            return .just(.failure(NetworkError.invalidURL))
        }
        
        return self.fetchData(stationType: 2, api: StreamingAPI(of: url), decodingType: TerrestrialApi.self)
            .map { terrestrialURL in
                guard let urlString = terrestrialURL.channelItem.first?.serviceUrl else {
                    return .failure(NetworkError.invalidJSON)
                }
                return .success(URL(string: urlString))
            }
            .catch { _ in
                return .just(Result<URL?, NetworkError>.failure(NetworkError.apiError))
            }
            .asSingle()
    }
    
    
    func getStringToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        guard let url = URL(string: urlString) else {
            return .just(.failure(NetworkError.invalidURL))
        }
        
        return self.fetchData(stationType: 1, api: StreamingAPI(of: url), decodingType: Data.self)
            .map { data in
                let convertValue = String(decoding: data, as: UTF8.self).split(whereSeparator: \.isNewline)
                for i in 0..<convertValue.count {
                    if convertValue[i].contains("File1=") {
                        let urlString = convertValue[1].components(separatedBy: "File1=").joined()
                        return .success(URL(string: urlString))
                    }
                }
                return .failure(NetworkError.invalidJSON)
            }
            .catch { _ in
                return .just(Result.failure(NetworkError.apiError))
            }
            .asSingle()
    }
    
    func validStreamURL(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        guard let url = URL(string: urlString) else {
            return .just(.failure(NetworkError.invalidStreamURL))
        }
        
        if UIApplication.shared.canOpenURL(url) {
            return .just(Result.success(url))
        } else {
            return .just(Result.failure(NetworkError.invalidStreamURL))
        }
    }
    
}
