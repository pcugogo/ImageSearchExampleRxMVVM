//
//  SearchViewController.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit
import Kingfisher
import Combine
import CombineCocoa

private enum Section: Hashable {
    case imageDatas
}

private enum Item: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .imageData(_, let index):
            hasher.combine(index)
        }
    }
    
    static func == (left: Item, right: Item) -> Bool {
        switch (left, right) {
        case (.imageData(_, let leftIndex), .imageData(_, let rightIndex)):
            return leftIndex == rightIndex
        }
    }
    
    case imageData(ImageData, index: Int)
}

private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

final class SearchViewController: BaseViewController, ViewModelBindable {
    var viewModel: SearchViewModel!
    
    private let searchController: UISearchController = .init()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private lazy var dataSource: DataSource = UICollectionViewDiffableDataSource<Section, Item>(
        collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .imageData(let imageData, _):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: ImageCollectionViewCell.self),
                    for: indexPath
                ) as! ImageCollectionViewCell
                cell.setImage(urlString: imageData.imageURL)
                return cell
            }
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

// MARK: - setupViews
extension SearchViewController {
    private func setupViews() {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        collectionView.collectionViewLayout = compositionalLayout
    }
}

// MARK: - BindViewModel
extension SearchViewController {
    // MARK: - Inputs
    func bindViewModelInputs() {
        searchController.searchBar.searchButtonClickedPublisher
            .sink(receiveValue: { [weak self] in
                guard let text = self?.searchController.searchBar.text else { return }
                guard text.isEmpty == false else {
                    self?.showAlert(title: "", message: "키워드를 입력해 주세요.")
                    return
                }
                
                self?.searchController.dismiss(animated: true, completion: nil)
                self?.viewModel.input.searchWithKeyword.send(text)
            })
            .store(in: &cancellables)

        collectionView.willDisplayCellPublisher
            .map { $0.indexPath }
            .sink(receiveValue: { [weak self] in
                self?.viewModel.input.willDisplayCellIndexPath.send($0)
            })
            .store(in: &cancellables)
        
        collectionView.didSelectItemPublisher
            .sink(receiveValue: { [weak self] in
                self?.viewModel.input.selectedItemIndexPath.send($0)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Outputs
    func bindViewModelOutputs() {
        viewModel.output.imageDatas
            .sink(receiveValue: { [weak self] in
                var snapshot = Snapshot()
                let items = $0.enumerated()
                    .map { offset, imageData -> Item in
                        return Item.imageData(imageData, index: offset)
                    }
                snapshot.appendSections([.imageDatas])
                snapshot.appendItems(items, toSection: .imageDatas)
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            })
            .store(in: &cancellables)
        
        viewModel.output.networkError
            .sink(receiveValue: { [weak self] error in
                self?.showAlert(title: "네트워크 오류", message: error.message)
            })
            .store(in: &cancellables)
    }
}

// MARK: CompositionalLayout
private extension SearchViewController {
    var compositionalLayout: UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1/3)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item, item, item]
            )
            
            return NSCollectionLayoutSection(group: group)
        }
    }
}
