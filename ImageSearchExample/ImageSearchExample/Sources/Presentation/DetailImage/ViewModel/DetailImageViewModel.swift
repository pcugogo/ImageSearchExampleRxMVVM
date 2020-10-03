//
//  DetailImageViewModel.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/05/26.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

protocol DetailImageViewModelTypeInputs {
    var favoriteButtonAction: PublishRelay<Void> { get }
}

protocol DetailImageViewModelTypeOutputs {
    var imageURLString: Observable<String> { get }
    var isAddFavorites: Driver<Bool> { get }
}

protocol DetailImageViewModelType: DetailImageViewModelTypeInputs, DetailImageViewModelTypeOutputs {
    var inputs: DetailImageViewModelTypeInputs { get }
    var outputs: DetailImageViewModelTypeOutputs { get }
}

final class DetailImageViewModel: DetailImageViewModelType {
    private var disposeBag = DisposeBag()
    
    // MARK: - Inputs
    var inputs: DetailImageViewModelTypeInputs { return self }
    var favoriteButtonAction: PublishRelay<Void> = .init()
    // MARK: - outputs
    var outputs: DetailImageViewModelTypeOutputs { return self }
    var imageURLString: Observable<String>
    var isAddFavorites: Driver<Bool>
    
    init(dependency: DetailImageDependency) {
        let isAddFavorites: BehaviorRelay<Bool> = .init(value: dependency.imageFavoritesStorage.isAddedFavorite(forKey: dependency.imageURLString))
        let imageURLString: BehaviorRelay<String> = .init(value: dependency.imageURLString)
        self.imageURLString = imageURLString.asObservable()
        
        //즐겨찾기 업데이트
        favoriteButtonAction.withLatestFrom(imageURLString)
            .map { dependency.imageFavoritesStorage.updateFavorite(forKey: $0) }
            .bind(to: isAddFavorites)
            .disposed(by: disposeBag)
        
        self.isAddFavorites = isAddFavorites.asDriver(onErrorDriveWith: .empty())
    }
}
