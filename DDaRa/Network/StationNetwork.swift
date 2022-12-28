//
//  StationNetwork.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/21.
//

import Foundation
import RxSwift
import RxCocoa



class StationNetwork {
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getStationList(_ fileName: String) -> Single<Result<StationList, NetworkError>> {
        let radioURL = "https://firebasestorage.googleapis.com/v0/b/ddara-fa50b.appspot.com/o/\(fileName).json?alt=media&token=b89634c9-781e-4eeb-a1af-0fecf79a6ce0"
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
}
