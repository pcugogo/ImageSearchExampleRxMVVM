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
        let fetchFavoritesUseCase: FetchFavoritesUseCaseType
    }
    struct Input {
        let favoriteButtonAction: Signal<Void>
    }
    struct Output {
        let imageURLString: Signal<String>
        let isAddFavorites: Driver<Bool>
    }    
    
    var steps: PublishRelay<Step> = .init()
    private var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let imageURLString = dependency.value.imageURLString
        let isAddFavorites: BehaviorRelay<Bool> = .init(
            value: dependency.value.fetchFavoritesUseCase.isContains(imageURLString)
        )
        
        input.favoriteButtonAction
            .asObservable()
            .withLatestFrom(self.dependency)
            .map { $0.fetchFavoritesUseCase.update($0.imageURLString) }
            .bind(to: isAddFavorites)
            .disposed(by: disposeBag)
        
        return Output(
            imageURLString: Observable<String>.just(imageURLString).asSignal(onErrorSignalWith: .empty()),
            isAddFavorites: isAddFavorites.asDriver(onErrorDriveWith: .empty())
        )
    }
}
