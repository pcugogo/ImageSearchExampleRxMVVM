//
//  ViewBindable.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 14/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

protocol ViewModelBindable {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModelInputs()
    func bindViewModelOutputs()
}

extension ViewModelBindable where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModelInputs()
        bindViewModelOutputs()
    }
}
