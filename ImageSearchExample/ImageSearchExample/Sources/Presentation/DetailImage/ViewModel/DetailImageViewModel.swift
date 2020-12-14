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
import SCoordinator

final class DetailImageViewModel: ViewModelType {

    struct Dependency {
        let imageURLString: String
        let imageFavoritesStorage: ImageFavoritesStorageType
    }
    struct Input {
        let favoriteButtonAction: PublishRelay<Void> = .init()
    }
    struct Output {
        let imageURLString: Signal<String>
        let isAddFavorites: Driver<Bool>
    }
    
    public let input: Input = .init()
    public let output: Output
    
    private var disposeBag = DisposeBag()
    
    init(coordinator: CoordinatorType, dependency: Dependency) {
        
        let isAddFavorites: BehaviorRelay<Bool> = .init(value: dependency.imageFavoritesStorage.isContains(dependency.imageURLString)
        )
        
        let imageURLString: Signal<String> = Observable
            .just(dependency.imageURLString)
            .asSignal(onErrorJustReturn: "")
        let depndency: BehaviorRelay<Dependency> = .init(value: dependency)
        
        input.favoriteButtonAction.asObservable().withLatestFrom(depndency)
            .map { $0.imageFavoritesStorage.update($0.imageURLString) }
            .bind(to: isAddFavorites)
            .disposed(by: disposeBag)
        
        output = Output(
            imageURLString: imageURLString,
            isAddFavorites: isAddFavorites.asDriver()
        )
    }
}
