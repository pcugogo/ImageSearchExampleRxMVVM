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
    var favoriteButtonAction: PublishRelay<Void> { get }
}

protocol DetailImageViewModelTypeOutputs {
    var imageURLString: Observable<String> { get }
    var isAddFavorites: Observable<Bool> { get }
}

protocol DetailImageViewModelType {
    var inputs: DetailImageViewModelTypeInputs { get }
    var outputs: DetailImageViewModelTypeOutputs { get }
}

final class DetailImageViewModel: DetailImageViewModelType, DetailImageViewModelTypeInputs, DetailImageViewModelTypeOutputs {
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Inputs
    var inputs: DetailImageViewModelTypeInputs { return self }
    var favoriteButtonAction: PublishRelay<Void> = .init()
    // MARK: - outputs
    var outputs: DetailImageViewModelTypeOutputs { return self }
    var imageURLString: Observable<String>
    var isAddFavorites: Observable<Bool>
    
    init(model: DetailImageModelType) {
        let isAddFavorites: BehaviorRelay<Bool> = .init(value: model.isAddedFavorites())
        self.imageURLString = .just(model.imageURLString)
        
        //즐겨찾기 업데이트
        favoriteButtonAction
            .map { model.updateFavorites() }
            .bind(to: isAddFavorites)
            .disposed(by: disposeBag)
        
        self.isAddFavorites = isAddFavorites.asObservable()
    }
}
