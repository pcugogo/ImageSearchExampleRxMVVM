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

final class SearchViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: SearchViewModelType!
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
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
            .drive(imagesCollectionView.rx.items) { collctionView, item, data in
                let indexPath = IndexPath(item: item, section: 0)
                let cell = collctionView.dequeueReusableCell(withReuseIdentifier: .init(describing: ImageCollectionViewCell.self),
                                                             for: indexPath) as! ImageCollectionViewCell
                cell.setImage(urlString: data.imageURL)
                return cell
        }
        .disposed(by: disposeBag)
        
        viewModel.outputs.errorMessage
            .emit(onNext: { [weak self] errorReason in
                guard let self = self else { return }
                self.showAlert("네트워크 오류", errorReason)
            })
            .disposed(by: disposeBag)
        
        imagesCollectionView.rx.itemSelected.withLatestFrom(viewModel.outputs.imagesCellItems, resultSelector: { ($0, $1) })
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard var detailImageViewController = storyboard.instantiateViewController(withIdentifier:
                    String(describing: DetailImageViewController.self)) as? DetailImageViewController
                    else { return }
                let imageURLString = $0.1[$0.0.item].imageURL
                detailImageViewController.bind(viewModel: DetailImageViewModel(
                    imageFavoritesStorage: UserDefaultsImageFavoritesStorage(),
                    imageURLString: imageURLString)
                )
                self.navigationController?.pushViewController(detailImageViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
