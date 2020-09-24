//
//  AppFlow.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class AppFlow: ViewControllerFlow {
    
    enum Target {
        case search
        
        var dependency: Container {
            var newDependency = Container()
            switch self {
            case .search:
                newDependency = SearchBuilder().build()
            }
            return newDependency
        }
    }
    
    init(target: Target) {
        super.init(dependency: target.dependency)
    }
}
