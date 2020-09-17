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
    
    var viewModel: SearchViewModelType!
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var searchBar: UISearchBar!
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.endEditing(true)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bindViewModel() {
        searchBar.rx.searchButtonClicked
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .filterEmpty()
            .do(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.imagesCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            })
            .bind(to: viewModel.inputs.searchButtonAction)
            .disposed(by: disposeBag)
        
        imagesCollectionView.rx.willDisplayCell
            .map { $0.at }
            .bind(to: viewModel.inputs.willDisplayCell)
            .disposed(by: disposeBag)
        
        viewModel.outputs.imagesCellItems
            .drive(imagesCollectionView.rx.items(dataSource: imagesDataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.errorMessage
            .emit(onNext: { [weak self] errorReason in
                guard let self = self else { return }
                self.showAlert("네트워크 오류", errorReason)
            })
            .disposed(by: disposeBag)
        
        imagesCollectionView.rx.itemSelected.withLatestFrom(
            viewModel.outputs.imagesCellItems,
            resultSelector: { ($0, $1) }
        )
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { [weak self] indexPath, sections in
                guard let self = self else { return }
                let imageURLString = sections[0].items[indexPath.item].imageURL
                let detailImageViewController = SearchBuilder(target: .detailImage(imageURLString: imageURLString))
                    .viewController()
                Coordinator.start(target: detailImageViewController,
                                  presentStyle: .push(navigationController: self.navigationController!),
                                  animated: true)
            })
            .disposed(by: disposeBag)
    }
}
