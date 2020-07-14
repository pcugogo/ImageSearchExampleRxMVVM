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

final class DetailImageViewController: UIViewController, ViewModelBindableType {
    
    var disposeBag = DisposeBag()
    var viewModel: DetailImageViewModelType!

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DetailImageViewController {
    func bindViewModel() {
        favoriteButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: viewModel.inputs.favoriteButtonAction)
            .disposed(by: disposeBag)
        
        viewModel.outputs.imageURLString
            .subscribe(onNext: {[weak self] in
                guard let self = self, let url = URL(string: $0) else { return }
                self.detailImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.isAddFavorites
            .drive(favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
