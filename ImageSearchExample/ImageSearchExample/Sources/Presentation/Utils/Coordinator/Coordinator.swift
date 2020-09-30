//
//  Coordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

typealias Coordinator = BaseCoordinator & Coordinatorable

protocol Coordinatorable {
    associatedtype Dependency
    func start(with dependency: Dependency)
}

protocol CoordinatorPresentable {
    associatedtype Target
    func present(to target: Target)
}

class BaseCoordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
