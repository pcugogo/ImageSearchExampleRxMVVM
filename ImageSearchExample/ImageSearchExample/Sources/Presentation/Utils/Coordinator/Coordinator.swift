//
//  Coordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

typealias Coordinator = BaseCoordinator & Coordinatable & CoordinatorType

enum CoordinatorRoute {
    case detailImage(imageURLString: String)
}

protocol CoordinatorType: class {
    func navigate(to route: CoordinatorRoute)
}

protocol Dependency {}

protocol Coordinatable: class {
    associatedtype DependencyType: Dependency
    func start(with dependency: DependencyType)
}

class BaseCoordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
