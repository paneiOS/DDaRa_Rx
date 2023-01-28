//
//  PlayStatusView.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/22.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa
import MediaPlayer

final class PlayStatusView: UIView {
    private let disposeBag = DisposeBag()
    var viewModel: PlayStatusViewModel!
    
    private let statusBarWidth = UIScreen.main.bounds.size.height / 25
    
    private let cdSubView: UIView = {
        let view = UIView()
        view.tintColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    private let cdImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray4
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let stationLabel: UILabel = {
        let label = UILabel()
        label.text = "방송을 선택해주세요."
        label.textColor = .white
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(systemName: "play.fill", pointSize: 200, state: .normal)
        button.setImage(systemName: "stop.fill", pointSize: 200, state: .selected)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: PlayStatusViewModel, topViewController: MainTabBarController) {
        self.init()
        self.viewModel = viewModel
        bind(to: topViewController)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRound()
    }
    
    func bind(to topViewController: UIViewController) {
        let playButtonTapped = playButton.rx.tap
            .withLatestFrom(playButton.rx.isSelected)
            .share()
        
        let input = PlayStatusViewModel.Input(playButtonTapped: playButtonTapped)
        let output = viewModel.transform(input: input)
        
        output.playButtonTapped
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] _ in
                if (false == self?.playButton.isSelected) {
                    self?.play()
                } else {
                    self?.pause()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bind(to input: PlayStatusViewModel.PlayInput) {
        let playOutput = viewModel.transform(input: input)
        
        playOutput.alertActionTapped
            .filter { $0 == .play }
            .withLatestFrom(input.stationInfo)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] info in
                self?.stationLabel.text = info.title
                self?.cdImageView.kf.setImage(with: URL(string: info.imageURL), placeholder: UIImage(systemName: "photo"))
                self?.play()
                self?.updateImageColor(info.imageColor)
                self?.remoteCommandInfocenterSetting(title: info.title, subTitle: info.subTitle, imageUrl: info.imageURL)
            })
            .disposed(by: disposeBag)
        
        playOutput.errorMessage
            .compactMap{$0}
            .do(onNext: { [weak self] _ in
                self?.pause()
            })
            .asDriver(onErrorDriveWith: .empty())
            .drive(getTopViewController().rx.setAlert)
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        [cdSubView, stationLabel, playButton].forEach {
            addSubview($0)
        }
        
        cdSubView.addSubview(cdImageView)
        
        cdSubView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(cdSubView.snp.height)
        }
        
        cdImageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        stationLabel.snp.makeConstraints {
            $0.leading.equalTo(cdSubView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        playButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(statusBarWidth)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(statusBarWidth)
        }
    }
    
    private func attribute() {
        backgroundColor = UIColor(white: 0, alpha: 0.4)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.white.cgColor
        remoteCommandCenterSetting()
    }
    
    private func updateImageColor(_ imageColor: String) {
        cdImageView
            .backgroundColor = UIColor(named: imageColor)
    }
    
    private func setupRound() {
        cdSubView.layer.cornerRadius = cdSubView.frame.size.height / 2
    }
    
    private func play() {
        DispatchQueue.main.async { [weak self] in
            self?.playButton.isSelected = true
            self?.cdImageView.startRotating()
        }
    }
    
    func pause() {
        DispatchQueue.main.async { [weak self] in
            self?.playButton.isSelected = false
            self?.cdImageView.stopRotating()
        }
    }
    
    private func remoteCommandInfocenterSetting(title: String, subTitle: String, imageUrl: String) {
        let center = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = center.nowPlayingInfo ?? [String: Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = subTitle
        
        downloadImage(with: imageUrl) { image in
            if let albumCoverImage = image {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: albumCoverImage.size, requestHandler: { size in
                    return albumCoverImage
                })
            }
        }
        
        center.nowPlayingInfo = nowPlayingInfo
    }
    
    private func remoteCommandCenterSetting() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let center = MPRemoteCommandCenter.shared()
        
        center.playCommand.addTarget { [weak self] (commandEvent) -> MPRemoteCommandHandlerStatus in
            self?.play()
            self?.viewModel.play()
            return MPRemoteCommandHandlerStatus.success
        }
        
        center.pauseCommand.addTarget { [weak self] (commandEvent) -> MPRemoteCommandHandlerStatus in
            self?.pause()
            self?.viewModel.pause()
            return MPRemoteCommandHandlerStatus.success
        }
    }
    
    private func getTopViewController() -> UIViewController {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return UIViewController()
        }
        guard let firstWindow = firstScene.windows.first else {
            return UIViewController()
        }
        guard let topViewController = firstWindow.rootViewController else {
            return UIViewController()
        }
        return topViewController
    }
    
    private func downloadImage(with urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void){
        guard let url = URL.init(string: urlString) else {
            return  imageCompletionHandler(nil)
        }
        let resource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                imageCompletionHandler(value.image)
            case .failure:
                imageCompletionHandler(nil)
            }
        }
    }
}
