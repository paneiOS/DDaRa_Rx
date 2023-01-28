//
//  StationNetwork.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import Foundation
import RxSwift

protocol SearchStationsUseCase {
    func getStationList() -> Single<Result<StationList, NetworkError>>
    func getJsonToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>>
    func getStringToUrl(of urlString: String) -> Single<Result<URL?, NetworkError>>
    func validStreamURL(of urlString: String) -> Single<Result<URL?, NetworkError>>
}

class NetworkService: SearchStationsUseCase {
    private let session: URLSession
    private let radioURL: String
    
    init(session: URLSession = .shared) {
        self.session = session
        self.radioURL =
        "https://firebasestorage.googleapis.com/v0/b/ddara-fa50b.appspot.com/o/stationList.json?alt=media&token=2baa6f1f-66fb-46f3-91dd-f9ecd853360b"
    }
    
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
