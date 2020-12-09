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
import RxFlow

final class DetailImageViewModel: ViewModel<DetailImageViewModel.Dependency>, Stepper {

    struct Dependency: DependencyType {
        let imageURLString: String
        let imageFavoritesStorage: ImageFavoritesStorageType
    }
    struct Input {
        let favoriteButtonAction: Driver<Void>
    }
    struct Output {
        let imageURLString: Driver<String>
        let isAddFavorites: Driver<Bool>
    }    
    
    var steps: PublishRelay<Step> = .init()
    private var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let isAddFavorites: BehaviorRelay<Bool> = .init(value: dependency.imageFavoritesStorage.isContains(dependency.imageURLString))
        let imageURLString: Driver<String> = Observable.just(dependency.imageURLString)
            .asDriver(onErrorDriveWith: .empty())
        let depndency: BehaviorRelay<Dependency> = .init(value: dependency)
        
        input.favoriteButtonAction.asObservable().withLatestFrom(depndency)
            .map { $0.imageFavoritesStorage.update($0.imageURLString) }
            .bind(to: isAddFavorites)
            .disposed(by: disposeBag)
        
        return Output(
            imageURLString: imageURLString,
            isAddFavorites: isAddFavorites.asDriver(onErrorDriveWith: .empty())
        )
    }
}
