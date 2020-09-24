//
//  ViewControllerFlow.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/24.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

protocol ViewControllerTargetable {
    associatedtype Target
    init(target: Target)
}

class BaseViewControllerFlow {

    private var dependency: Container = .init()
    
    init(dependency: Container) {
        self.dependency = dependency
    }
    
    func viewController() -> UIViewController {
        guard let controller = dependency.resolve(type: UIViewController.self) else {
            fatalError("\(String(describing: self)): The view controller could not be found.")
        }
        return controller
    }
}

typealias ViewControllerFlow = ViewControllerTargetable & BaseViewControllerFlow
