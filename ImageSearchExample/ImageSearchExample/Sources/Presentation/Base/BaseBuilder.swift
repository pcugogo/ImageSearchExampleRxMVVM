//
//  BaseBuilder.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/17.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

class BaseBuilder {
    var dependency: Container
    
    init(dependency: Container) {
        self.dependency = dependency
    }
    
    func viewController() -> UIViewController {
        guard let controller = dependency.resolve(type: UIViewController.self) else {
            fatalError("Failed to create view controller. Make sure the view controller is added to the dependency container")
        }
        return controller
    }
}
