//
//  ViewModel.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/10/06.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift
import RxCocoa

typealias ViewModel = BaseViewModel & ViewModelType

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class BaseViewModel {
    let coordinator: Observable<CoordinatorType>
    let dependency: Dependency
    
    init(coordinator: CoordinatorType, dependency: Dependency) {
        self.coordinator = BehaviorRelay<CoordinatorType>(value: coordinator)
            .asObservable()
        self.dependency = dependency
    }
}
