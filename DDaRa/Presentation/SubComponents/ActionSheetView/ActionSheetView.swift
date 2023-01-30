//
//  ActionSheetView.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/04.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class ActionSheetView: UIView {
    private let disposeBag = DisposeBag()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray4
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.setup(.label, 20)
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.setup(.secondaryLabel, 15)
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.setup(.label, 15)
        label.numberOfLines = 0
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .red
        button.setImage(systemName: "heart", pointSize: 200, state: .normal)
        button.setImage(systemName: "heart.fill", pointSize: 200, state: .selected)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActionSheetView {
    private func setupUI() {
        [mainView, label, subLabel, detailLabel, likeButton].forEach {
            addSubview($0)
        }
        
        mainView.addSubview(imageView)
        
        mainView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(mainView.snp.height)
        }
        
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10).offset(10)
            $0.leading.equalTo(mainView.snp.trailing).offset(10)
            $0.trailing.equalTo(likeButton.snp.leading).inset(-2)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(2)
            $0.leading.equalTo(mainView.snp.trailing).offset(10)
            $0.trailing.equalTo(likeButton.snp.leading).inset(10)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(3)
            $0.leading.equalTo(mainView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
        likeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.width.height.equalTo(UIScreen.main.bounds.size.width * 0.05)
            } else {
                $0.trailing.equalToSuperview().inset(2)
                $0.width.height.equalTo(UIScreen.main.bounds.size.width * 0.1)
            }
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
    
    func updateUI(to output: Observable<StationCellData>) {
        output.subscribe(onNext: { [weak self] info in
            self?.label.text = info.title
            self?.likeButton.isSelected = UserDefaults.standard.bool(forKey: info.title)
            self?.subLabel.text = info.subTitle
            self?.detailLabel.text = info.detail
            self?.imageView.backgroundColor = UIColor(named: info.imageColor)
            self?.imageView.kf.setImage(with: URL(string: info.imageURL), placeholder: UIImage(systemName: "photo"))
        })
        .disposed(by: disposeBag)
        
        likeButton.rx.tap
            .withLatestFrom(likeButton.rx.isSelected)
            .subscribe(onNext: { [weak self] _ in
                self?.updateButton()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func updateButton() {
        guard let name = label.text else { return }
        likeButton.isSelected = !likeButton.isSelected
        UserDefaults.standard.set(likeButton.isSelected, forKey: name)
        if likeButton.isSelected {
            let count = UserDefaults.standard.integer(forKey: "favoriteCount")
            UserDefaults.standard.set(count + 1, forKey: "favoriteCount")
        } else {
            let count = UserDefaults.standard.integer(forKey: "favoriteCount")
            UserDefaults.standard.set(count - 1, forKey: "favoriteCount")
        }
    }
}
