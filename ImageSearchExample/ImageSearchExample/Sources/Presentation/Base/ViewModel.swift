//
//  ViewModel.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/10/06.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift
import RxCocoa
import SCoordinator

typealias ViewModel = ViewModelType & BaseViewModel

protocol ViewModelType {
    
    associatedtype Dependency
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
    
    init(coordinator: CoordinatorType, dependency: Dependency)
}

class BaseViewModel: Coordinatable {
    var coordinator: CoordinatorType!
}
