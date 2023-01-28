//
//  FavoriteListTableView.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class FavoriteListTableView: UITableView {
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        let footer = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height / 10
        ))
        footer.backgroundColor = .white
        tableFooterView = footer
        
        register(FavoriteListCell.self, forCellReuseIdentifier: "FavoriteListCell")
        separatorStyle = .singleLine
        rowHeight = UIScreen.main.bounds.size.height / 10
    }
}
