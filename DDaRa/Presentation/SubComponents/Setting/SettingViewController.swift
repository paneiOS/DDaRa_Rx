//
//  SettingViewController.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/25.
//

import UIKit
import RxSwift

class SettingViewController: UIViewController {
    private let tableView = UITableView()
    private let cellData: [String] = ["자동종료 설정"]
    private let actions: SleepSettingAction?
    var playStatusView: PlayStatusView!
    
    let disposeBag = DisposeBag()
    
    init(playStatusView: PlayStatusView, actions: SleepSettingAction) {
        self.playStatusView = playStatusView
        self.actions = actions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttribute()
        bind()
    }
}

extension SettingViewController {
    private func bind() {
        Observable.of(cellData)
            .bind(to: tableView.rx.items) { (tv, row, item) in
                let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
                cell.textLabel?.text = item
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                self?.actions?.showSleepSettingViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupAttribute() {
        title = "설정"
        view.backgroundColor = .white
    }
}
