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
    // MARK: - Inputs
    func bindViewModelInputs() {
        
        favoriteButton.rx.tap
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.favoriteButtonAction)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Outputs
    func bindViewModelOutputs() {
        
        viewModel.output.imageURLString.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self, let url = URL(string: $0) else { return }
                self.detailImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isAddFavorites
            .drive(favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
