//
//  ViewModel.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/10/06.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift
import RxCocoa

typealias ViewModel<Dependency: DependencyType> = BaseViewModel<Dependency> & ViewModelTransformable

protocol ViewModelTransformable {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

protocol DependencyType {}

class BaseViewModel<Dependency: DependencyType> {
    let coordinator: Observable<CoordinatorType>
    let dependency: Dependency
    
    init(coordinator: CoordinatorType, dependency: Dependency) {
        self.coordinator = BehaviorRelay<CoordinatorType>(value: coordinator)
            .asObservable()
        self.dependency = dependency
    }
}
