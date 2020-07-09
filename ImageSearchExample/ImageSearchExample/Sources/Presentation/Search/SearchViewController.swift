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

final class SearchViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupBindings(viewModel: SearchViewModelType = SearchViewModel()) {
        searchBar.rx.searchButtonClicked
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
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
            .bind(to: imagesCollectionView.rx
                .items(cellIdentifier: String(describing: ImageCollectionViewCell.self),
                       cellType: ImageCollectionViewCell.self)) { _, item, cell in
                cell.setImage(urlString: item.imageURL)
        }
        .disposed(by: disposeBag)
        
        viewModel.outputs.errorMessage
            .emit(onNext: { [weak self] errorReason in
                guard let self = self else { return }
                self.showAlert("네트워크 오류", errorReason)
            })
            .disposed(by: disposeBag)
        
        imagesCollectionView.rx.itemSelected
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard var detailImageViewController = storyboard.instantiateViewController(withIdentifier:
                    String(describing: DetailImageViewController.self)) as? DetailImageViewController
                    else { return }
                let imageURLString = viewModel.outputs.imagesCellItems.value[indexPath.item].imageURL
                let model = DetailImageModel(imageURLString: imageURLString)
                detailImageViewController.bind(viewModel: DetailImageViewModel(model: model))
                self.navigationController?.pushViewController(detailImageViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
