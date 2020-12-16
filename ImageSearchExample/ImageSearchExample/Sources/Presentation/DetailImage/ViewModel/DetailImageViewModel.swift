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
    
    init(
        coordinator: CoordinatorType,
        imageURLString: String,
        fatchFavoritesUseCase: FetchFavoritesUseCaseType = FetchFavoritesUseCase()
    ) {
        let isAddFavorites: BehaviorRelay<Bool> = .init(value: fatchFavoritesUseCase.isContains(imageURLString))

        input.favoriteButtonAction
            .map { fatchFavoritesUseCase.update(imageURLString) }
            .bind(to: isAddFavorites)
            .disposed(by: disposeBag)
        
        let imageURLString: Signal<String> = Observable
            .just(imageURLString)
            .asSignal(onErrorJustReturn: "")
        
        output = Output(
            imageURLString: imageURLString,
            isAddFavorites: isAddFavorites.asDriver()
        )
    }
}
