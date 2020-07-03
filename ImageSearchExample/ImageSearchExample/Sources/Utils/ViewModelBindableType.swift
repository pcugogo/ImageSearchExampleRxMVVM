//
//  ViewModelBindableType.swift
//  ImageSearchExample
//
//  Created by ChanWookPark on 2020/05/26.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
