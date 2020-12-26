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
    
    let searchController: UISearchController = .init()
    
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
        setAttributes()
    }
}

// MARK: - setAttributes
extension SearchViewController {
    
    private func setAttributes() {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
}

// MARK: - BindViewModel
extension SearchViewController {
    // MARK: - Inputs
    func bindViewModelInputs() {
        
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .map { String($0) }
            .filterEmpty()
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.searchController.dismiss(animated: true, completion: nil)
            })
            .bind(to: viewModel.input.searchButtonAction)
            .disposed(by: disposeBag)
        
        imagesCollectionView.rx.willDisplayCell
            .map { $0.at }
            .bind(to: viewModel.input.willDisplayCell)
            .disposed(by: disposeBag)
        
        imagesCollectionView.rx.itemSelected
            .bind(to: viewModel.input.itemSeletedAction)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Outputs
    func bindViewModelOutputs() {
        
        viewModel.output.imagesSections
            .asObservable()
            .bind(to: imagesCollectionView.rx.items(dataSource: imagesDataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.networkError
            .asObservable()
            .do(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showAlert("네트워크 오류", error.message)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}
