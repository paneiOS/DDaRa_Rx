//
//  PlayStatusViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/22.
//

import RxSwift
import RxCocoa
import Foundation
import AVFoundation

class PlayStatusViewModel {
    let disposeBag = DisposeBag()
    private let player = AVPlayer()
    
    private let network = StationNetwork()
    let playStart = PublishRelay<Void>()
    let stationSelected = PublishRelay<StationCellData>()
    
    let stationInfo: Driver<StationCellData>
    let streamURL: Observable<URL?>
    
    init() {
        stationInfo = stationSelected
            .asDriver(onErrorJustReturn: StationCellData(name: "", imageURL: "", streamURL: "", like: false))
        
        streamURL = stationSelected
            .map { station -> URL? in
                return URL(string: station.streamURL)
            }
        
        streamURL
            .subscribe(onNext: { [weak self] url in
                guard let url = url else { return }
                let item = AVPlayerItem(url: url)
                self?.player.replaceCurrentItem(with: item)
            })
            .disposed(by: disposeBag)
    }
    
    func play() {
        guard player.currentItem != nil else { return }
        player.play()
    }
    
    func pause() {
        player.pause()
    }
}
