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
import AVFoundation

class PlayStatusView: UIView {
    private let disposeBag = DisposeBag()
    private let player = AVPlayer()
    
    private let statusBarWidth = UIScreen.main.bounds.size.height / 25
    
    private let cdSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    private let cdImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "logo")
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRound()
    }
    
    func bind(_ viewModel: PlayStatusViewModel) {
        viewModel.playStart
            .withLatestFrom(viewModel.stationInfo)
            .asDriver(onErrorJustReturn: StationCellData(name: "", imageURL: "", streamURL: "", like: false))
            .drive(onNext: { [weak self] station in
                guard let url = URL(string: station.streamURL) else { return }
                let item = AVPlayerItem(url: url)
                self?.player.replaceCurrentItem(with: item)
                self?.stationLabel.text = station.name
                self?.cdImageView.kf.setImage(with: URL(string: station.imageURL), placeholder: UIImage(systemName: "photo"))
                self?.play()
            })
            .disposed(by: disposeBag)
        
        playButton.rx.tap
            .bind(onNext: { [weak self] _ in
                if (false == self?.playButton.isSelected) {
                    self?.play()
                } else {
                    self?.pause()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        [cdSubView, stationLabel, playButton].forEach {
            addSubview($0)
        }
        
        cdSubView.addSubview(cdImageView)
        
        cdSubView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(5)
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
    }
    
    func setupRound() {
        cdSubView.layer.cornerRadius = cdSubView.frame.size.height / 2
    }
    
    private func play() {
        guard player.currentItem != nil else { return }
        player.play()
        playButton.isSelected = true
        cdImageView.startRotating()
    }
    
    private func pause() {
        player.pause()
        playButton.isSelected = false
        cdImageView.stopRotating()
    }
    
}
