//
//  SearchViewController.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxOptional
import RxDataSources

final class SearchViewController: UIViewController, ViewModelBindable {
    
    typealias ImagesDataSource = RxCollectionViewSectionedReloadDataSource<ImagesSection>
    
    var viewModel: SearchViewModel!
    private var disposeBag = DisposeBag()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        return searchController
    }()
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    private let imagesDataSource = ImagesDataSource(configureCell: { _, collectionView, indexPath, data in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionViewCell.self),
                                                            for: indexPath) as? ImageCollectionViewCell else {
                                                                fatalError()
        }
        cell.setImage(urlString: data.imageURL)
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - BindViewModel
extension SearchViewController {
    // MARK: - Inputs
    func bindViewModelInput() -> SearchViewModel.Input {
        let searchButtonClicked = searchController.searchBar.rx.searchButtonClicked
            .asDriver()
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty.asDriver())
            .filterEmpty()
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.searchController.dismiss(animated: true, completion: nil)
            })
        
        let willDisplayCell = imagesCollectionView.rx.willDisplayCell
            .asDriver()
            .map { $0.at }
        
        let itemSeleted = imagesCollectionView.rx.itemSelected
            .asDriver()
        
        let input = SearchViewModel.Input(
            searchButtonAction: searchButtonClicked,
            willDisplayCell: willDisplayCell,
            itemSeletedAction: itemSeleted
        )
        
        return input
    }
    
    // MARK: - Outputs
    func bindViewModelOutput(_ input: SearchViewModel.Input) {
        let output = viewModel.transform(input: input)
        
        output.imagesSections
            .drive(imagesCollectionView.rx.items(dataSource: imagesDataSource))
            .disposed(by: disposeBag)
        
        output.networkError
            .emit(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showAlert("네트워크 오류", error.message)
            })
            .disposed(by: disposeBag)
    }
}
