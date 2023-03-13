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

final class SearchViewController: BaseViewController, ViewModelBindable {
    
    typealias ImagesDataSource = RxCollectionViewSectionedReloadDataSource<ImagesSection>
    
    var viewModel: SearchViewModel!
    let searchController: UISearchController = .init()
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    private let imagesDataSource = ImagesDataSource(configureCell: { _, collectionView, indexPath, data in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ImageCollectionViewCell.self),
            for: indexPath
        ) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
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
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.searchController.dismiss(animated: true, completion: nil)
            })
            .subscribe(onNext: { [weak self] in
                guard $0.isEmpty == false else {
                    self?.showAlert(title: "", message: "검색어를 입력해 주세요.")
                    return
                }
                
                self?.viewModel.input.searchWithKeyword.accept($0)
            })
            .disposed(by: disposeBag)
        
        imagesCollectionView.rx.willDisplayCell
            .map { $0.at }
            .bind(to: viewModel.input.willDisplayCellIndexPath)
            .disposed(by: disposeBag)
        
        imagesCollectionView.rx.itemSelected
            .bind(to: viewModel.input.selectedItemIndexPath)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Outputs
    func bindViewModelOutputs() {
        viewModel.output.imageDatas
            .map { [ImagesSection(model: Void(), items: $0)] }
            .drive(imagesCollectionView.rx.items(dataSource: imagesDataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.networkError
            .emit(onNext: { [weak self] error in
                self?.showAlert(title: "네트워크 오류", message: error.message)
            })
            .disposed(by: disposeBag)
    }
}
