//
//  StationNetwork.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import Foundation
import Moya
import RxSwift

protocol SearchStationsUseCase {
    func getStationList() -> Single<Result<StationList, NetworkError>>
    func getJsonToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>>
    func getStringToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>>
    func validStreamURL(of urlString: String) -> Single<Result<URL?, NetworkError>>
}

class NetworkService: SearchStationsUseCase {
    private let provider = MoyaProvider<StationAPI>()
    private let session: URLSession
    private let radioURL: String
    private let disposeBag = DisposeBag()
    
    init(session: URLSession = .shared) {
        self.session = session
        self.radioURL =
        "https://raw.githubusercontent.com/kazamajinz/DDaRa_Rx/2781a73fa8a5875d6001c9b9e5b73ba1b2d78e9c/StationList.json"
    }
    
    public func temp() -> Single<Result<StationList.Response, NetworkError>> {
        
        
        return provider.request(.getStations) { result in
            self.process(type: StationList.Response.self, result: result)
        }
    }
    /*
     func getStationList2() -> Single<Result<StationList, NetworkError>> {
     //        let temp =
     //        Observable.create {
     //
     //        }
     //        return
     //        provider.rx.request(.getStations)
     //            .map(StationList.Response.self)
     //            .asSignal(onErrorSignalWith: .empty())
     
     return Single<Result<StationList, NetworkError>>.create { single in
     
     
     
     
     //               guard let url = url else {
     //                   single(.error(NSError.init(domain: "error", code: -1, userInfo: nil)))
     //                   return Disposables.create()
     //               }
     //
     //               if url == "https://www.google.com" {
     //                   single(.success(true))
     //               } else {
     //                   single(.success(false))
     //               }
     
     single(.success(provider.rx.request(.getStations)
     .map(StationList.Response.self)))
     
     return Disposables.create()
     }
     //            .subscribe { event in
     //                switch event {
     //                case.success(let str):
     //                    print("str2", str)
     //                case .failure(let err):
     //                    print("err2", err)
     //                }
     //            }
     //            .disposed(by: disposeBag)
     //            .map { $0 }
     
     //            .catch { _ in
     //                return .just(Result.failure(NetworkError.networkError))
     //            }
     //            .asSingle()
     /*
      provider.rx.request(.getStations)
      .map(StationList.self)
      .subscribe { event in
      switch event {
      case.success(let str):
      print("str2", str)
      case .failure(let err):
      print("err2", err)
      }
      }
      .disposed(by: disposeBag)
      */
     }
     
     
     provider.rx.request(.searchUser(query: query))
     .subscribe { [weak self] (event) in
     switch event {
     case .success(let response):
     print(response)
     case .error(let error):
     print(error.localizedDescription)
     }
     }
     .disposed(by: disposeBag)
     */
    
    func getStationList() -> Single<Result<StationList, NetworkError>> {
        guard let url = URL(string: radioURL) else {
            return .just(.failure(NetworkError.invalidURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let stationListData = try JSONDecoder().decode(StationList.self, from: data)
                    return .success(stationListData)
                } catch {
                    return .failure(NetworkError.invalidJSON)
                }
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
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let terrestrialURL = try JSONDecoder().decode(TerrestrialApi.self, from: data)
                    guard let urlString = terrestrialURL.channelItem.first?.serviceUrl else {
                        return .failure(NetworkError.invalidJSON)
                    }
                    return .success(URL(string: urlString))
                } catch {
                    return .failure(NetworkError.invalidJSON)
                }
            }
            .catch { _ in
                return .just(Result.failure(NetworkError.apiError))
            }
            .asSingle()
    }
    
    func getStringToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>> {
        guard let url = URL(string: urlString) else {
            return .just(.failure(NetworkError.invalidURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.rx.data(request: request as URLRequest)
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

//enum DecodeError: NetworkError {
//    case decodeError
//}

extension NetworkService {
    
    func process<T: Decodable, E>(
        type: T.Type,
        result: Result<Response, MoyaError>,
        completion: @escaping (Result<E, NetworkError>) -> Void
    ) {
        switch result {
        case .success(let response):
            if let data = try? JSONDecoder().decode(type, from: response.data) {
                completion(.success(data as! E))
            } else {
                completion(.failure(NetworkError.invalidJSON))
            }
        case .failure(let error):
            completion(.failure(NetworkError.networkError))
        }
    }
    
}
