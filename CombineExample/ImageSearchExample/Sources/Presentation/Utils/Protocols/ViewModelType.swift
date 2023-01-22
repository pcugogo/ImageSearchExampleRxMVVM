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

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
