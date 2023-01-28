//
//  StationView.swift
//  DDaRaPodcasts
//
//  Created by Pane on 2022/10/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class StationView: UIViewController {
    var viewModel: StationViewModel!
    var playStatusView: PlayStatusView!
    var backgroundView: StationBackgroundView!
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfStations>!
    private let disposeBag = DisposeBag()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.register(CollectionViewMainCell.self, forCellWithReuseIdentifier: "CollectionViewMainCell")
        collectionView.register(CollectionViewBasicCell.self, forCellWithReuseIdentifier: "CollectionViewBasicCell")
        collectionView.register(CollectionViewLabelCell.self, forCellWithReuseIdentifier: "CollectionViewLabelCell")
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        return collectionView
    }()

    convenience init(playStatusView: PlayStatusView, viewModel: StationViewModel, backgroundView: StationBackgroundView) {
        self.init()
        self.viewModel = viewModel
        self.playStatusView = playStatusView
        self.backgroundView = backgroundView
        configureCollectionViewDataSource()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttribute()
    }
}

extension StationView {
    private func bind() {
        let viewWillAppear = rx.viewWillAppear.asObservable().share()
        let cellSelected = collectionView.rx.modelSelected(StationCellData.self).asObservable().share()
        
        let input = StationViewModel.Input(viewWillAppear: viewWillAppear, cellSelected: cellSelected)
        let output = viewModel.transform(input: input)
        
        let actionSheetView = ActionSheetView(frame: CGRect(x: 10.0, y: 10.0, width: UIScreen.main.bounds.size.width - 40, height: 120.0))
        actionSheetView.updateUI(to: input.cellSelected)
        
        let alertActionTapped = output.alertSheet
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: alert.message, preferredStyle: alert.style)
                alertController.view.addSubview(actionSheetView)
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if let popoverController = alertController.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX,
                                                              y: self.view.bounds.midY,
                                                              width: 0,
                                                              height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                }
                return self.presentAlertController(self, alertController, actions: alert.actions)
            }
            .share()
        
        output.stations
            .asDriver(onErrorDriveWith: .empty())
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.errorMessage
            .asSignal(onErrorSignalWith: .empty())
            .compactMap{$0}
            .emit(to: rx.setAlert)
            .disposed(by: disposeBag)
        
        playStatusView.bind(to: PlayStatusViewModel.PlayInput(stationInfo: cellSelected, alertActionTapped: alertActionTapped))
        
        //MARK: - Background ViewModel
        backgroundView.bind(
            input: output.stations
        )
    }
    
    private func setupAttribute() {
        title = "따뜻한 라디오"
        view.backgroundColor = .white
        collectionView.backgroundView = backgroundView
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureCollectionViewDataSource() {
        let basicHeaderRegistration = UICollectionView.SupplementaryRegistration<CollectionViewHeader>(elementKind: "CollectionViewHeader") { headerView, item, indexPath in
            headerView.sectionNameLabel.text = Section.allCases[indexPath.section].id
        }
        let basicFooterRegistration = UICollectionView.SupplementaryRegistration<CollectionViewFooter>(elementKind: "CollectionViewFooter") { _, _, _ in
        }
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfStations>(configureCell: { dataSource, collectionView, indexPath, item in
            switch indexPath.section {
            case Section.지상파.index:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewMainCell", for: indexPath) as! CollectionViewMainCell
                cell.updateUI(imageName: item.imageURL)
                return cell
            case Section.CBS.index ... Section.교통방송.index:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewLabelCell", for: indexPath) as! CollectionViewLabelCell
                cell.updateUI(title: item.title, imageName: item.imageURL)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewBasicCell", for: indexPath) as! CollectionViewBasicCell
                cell.updateUI(imageName: item.imageURL, imageColor: item.imageColor)
                return cell
            }
            
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            switch kind {
            case "CollectionViewHeader":
                let header = collectionView.dequeueConfiguredReusableSupplementary(using: basicHeaderRegistration, for: indexPath)
                return header
            case "CollectionViewFooter":
                let footer = collectionView.dequeueConfiguredReusableSupplementary(using: basicFooterRegistration, for: indexPath)
                return footer
            default:
                return UICollectionReusableView()
            }
        })
    }
}

extension StationView: UICollectionViewDelegate {
    private func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {[weak self] sectionNumber, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            switch sectionNumber {
            case Section.지상파.index:
                return self.createMainTypeSection()
            case Section.CBS.index ... Section.기타종교.index:
                return self.createLabelTypeSection()
            case Section.교통방송.index:
                return self.createTBNTypeSection()
            default:
                return self.createBasicTypeSection()
            }
        }
    }
//
    private func createMainTypeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 10)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalWidth(0.4)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems  = [sectionHeader]
        section.contentInsets = .init(top: 0, leading: 5, bottom: 20, trailing: 5)
        return section
    }

    private func createBasicTypeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.2)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems  = [sectionHeader]
        section.contentInsets = .init(top: 0, leading: 5, bottom: 10, trailing: 5)
        return section
    }
    
    private func createLabelTypeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.8))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.2), heightDimension: .estimated(200)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems  = [sectionHeader]
        sectionHeader.contentInsets = .init(top: 0, leading: 5, bottom: 10, trailing: 5)
        return section
    }


    private func createTBNTypeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.8))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.2), heightDimension: .estimated(200)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = self.createSectionHeader()
        let sectionFooter = self.createSectionFooter()
        section.boundarySupplementaryItems  = [sectionHeader, sectionFooter]
        sectionHeader.contentInsets = .init(top: 0, leading: 5, bottom: 10, trailing: 5)
        return section
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: "CollectionViewHeader", alignment: .topLeading)
        return sectionHeader
    }

    private func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerHeight = UIScreen.main.bounds.size.height / 9
        let layoutSectionFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(footerHeight))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionFooterSize, elementKind: "CollectionViewFooter", alignment: .bottomLeading)
        return sectionFooter
    }
}

extension StationView: AlertController {}
