//
//  DetailImageViewModel.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/05/26.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

protocol DetailImageViewModelTypeInputs {
    var favoriteButtonAction: PublishSubject<Void> { get }
}

protocol DetailImageViewModelTypeOutputs {
    var imageURLString: Observable<String> { get }
    var isAddFavorites: Observable<Bool> { get }
}

protocol DetailImageViewModelType {
    var inputs: DetailImageViewModelTypeInputs { get }
    var outputs: DetailImageViewModelTypeOutputs { get }
}

struct DetailImageViewModel: DetailImageViewModelType, DetailImageViewModelTypeInputs, DetailImageViewModelTypeOutputs {

    private var disposeBag = DisposeBag()
    
    // MARK: - Inputs
    var inputs: DetailImageViewModelTypeInputs { return self }
    var favoriteButtonAction: PublishSubject<Void> = PublishSubject()
    // MARK: - outputs
    var outputs: DetailImageViewModelTypeOutputs { return self }
    var imageURLString: Observable<String>
    var isAddFavorites: Observable<Bool>
    
    init(imageURLString: Observable<String>, model: DetailImageModel = DetailImageModel()) {
        
        let isAddFavorites: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        
        favoriteButtonAction.withLatestFrom(imageURLString)
            .map { model.updateFavorites(url: $0) }
            .bind(to: isAddFavorites)
            .disposed(by: disposeBag)
        
        self.imageURLString = imageURLString
            .asObservable()
        
        imageURLString
            .map { url -> Bool in
                return model.isAddedFavorites(url: url)
        }
        .bind(to: isAddFavorites)
        .disposed(by: disposeBag)
        
        self.isAddFavorites = isAddFavorites.distinctUntilChanged().asObservable()
    }
}
