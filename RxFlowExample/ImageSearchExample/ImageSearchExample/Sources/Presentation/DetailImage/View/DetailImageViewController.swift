//
//  DetailImageViewController.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/05/18.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

final class DetailImageViewController: UIViewController, ViewModelBindable {
    
    var viewModel: DetailImageViewModel!
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - BindViewModel
extension DetailImageViewController {
    
    func bindViewModelInput() -> DetailImageViewModel.Input {
        let favoriteButtonAction = favoriteButton.rx.tap
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .asDriver(onErrorDriveWith: .empty())
        
        let input = DetailImageViewModel.Input(favoriteButtonAction: favoriteButtonAction)
        
        return input
    }
    
    func bindViewModelOutput(_ input: DetailImageViewModel.Input) {
        let output = viewModel.transform(input: input)
        
        output.imageURLString.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self, let url = URL(string: $0) else { return }
                self.detailImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        output.isAddFavorites
            .drive(favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
