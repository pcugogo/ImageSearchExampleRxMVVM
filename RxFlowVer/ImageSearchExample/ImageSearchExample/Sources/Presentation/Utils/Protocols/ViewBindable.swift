//
//  ViewBindable.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 14/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

protocol ViewModelBindable {
    associatedtype ViewModelType: ViewModelTransformable
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModelInput() -> ViewModelType.Input
    func bindViewModelOutput(_ input: ViewModelType.Input)
}

extension ViewModelBindable where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModelOutput(bindViewModelInput())
    }
}
