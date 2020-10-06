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

final class DetailImageViewModel: ViewModel {

    struct Input {
        var favoriteButtonAction: Observable<Void>
    }
    
    struct Output {
        var imageURLString: Observable<String>
        var isAddFavorites: Driver<Bool>
    }
    
    private var disposeBag = DisposeBag()
    private var detailImageDependency: DetailImageDependency {
        return dependency as! DetailImageDependency
    }
    
    func transform(input: Input) -> Output {
        
        let dependency = self.detailImageDependency
        
        let isAddFavorites: BehaviorRelay<Bool> = .init(value: dependency.imageFavoritesStorage.isContains(dependency.imageURLString))
        let imageURLString: BehaviorRelay<String> = .init(value: dependency.imageURLString)
        
        input.favoriteButtonAction.withLatestFrom(imageURLString)
            .map { dependency.imageFavoritesStorage.update($0) }
            .bind(to: isAddFavorites)
            .disposed(by: disposeBag)

        return Output(imageURLString: imageURLString.asObservable(),
                      isAddFavorites: isAddFavorites.asDriver(onErrorDriveWith: .empty()))
    }
}
