//
//  PlayStatusViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/22.
//

import RxSwift
import Foundation
import AVFoundation
import MediaPlayer

struct PlayStatusViewModel: ViewModel {
    let model: DefaultStationsUseCase
    let disposeBag = DisposeBag()
    let errorMessage = PublishSubject<Alert?>()
    let audioSession = AVAudioSession.sharedInstance()
    let player = AVPlayer()
    
    struct Input {
        let playButtonTapped: Observable<Bool>
    }
    
    struct Output {
        let playButtonTapped: Observable<Bool>
    }
    
    struct PlayInput {
        let stationInfo: Observable<StationCellData>
        let alertActionTapped: Observable<AlertAction>
    }
    
    struct PlayOutput {
        let stationInfo: Observable<StationCellData>
        let errorMessage: Observable<Alert?>
        let alertActionTapped: Observable<AlertAction>
    }
    
    init(useCase: DefaultStationsUseCase) {
        self.model = useCase
    }
    
    func transform(input: Input) -> Output {
        let playButtonTapped = input.playButtonTapped
            .filter { _ in player.status == .readyToPlay }
            .share()
        
        playButtonTapped
            .bind(onNext: { bool in
                if false == bool {
                    play()
                } else {
                    pause()
                }
            })
            .disposed(by: disposeBag)
        
        return PlayStatusViewModel.Output(
            playButtonTapped: playButtonTapped
        )
    }
    
    func transform(input: PlayInput) -> PlayOutput {
        let validStreamURL = input.alertActionTapped
            .filter{ $0 == .play }
            .do ( onNext: { _ in
                stop()
            })
            .withLatestFrom(input.stationInfo)
            .flatMapLatest(model.getStreamUrl)
            .share()
        
        validStreamURL
            .map(model.getStreamUrlValue)
            .bind(onNext: { url in
                if let url = url {
                    let item = AVPlayerItem(url: url)
                    player.replaceCurrentItem(with: item)
                    play()
                } else {
                    stop()
                }
            })
            .disposed(by: disposeBag)
        
        let validInfo = validStreamURL
            .withLatestFrom(input.stationInfo)
            .share()
        
        let errorMessage = validStreamURL
            .map(model.getStreamUrlError)
            .share()
        
        return PlayOutput(stationInfo: validInfo,
                          errorMessage: errorMessage,
                          alertActionTapped: input.alertActionTapped)
    }
    
    func play() {
        guard player.currentItem != nil else { return }
        player.play()
        setBackgoundPlay()
    }
    
    func pause() {
        player.pause()
    }
    
    func stop() {
        player.pause()
        player.replaceCurrentItem(with: nil)
    }
    
    func setBackgoundPlay() {
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
#if DEBUG
            print("백그라운드 재생 오류")
#endif
        }
    }
}
