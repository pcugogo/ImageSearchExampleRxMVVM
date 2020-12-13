//
//  Coordinator.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/13.
//

import UIKit

public typealias Coordinator<Root> = BaseCoordinator<Root> & Coordinatable & CoordinatorType

public protocol CoordinatorType: class {
    func navigate(to route: Route)
}

public protocol Coordinatable: class {
    associatedtype Dependency
    func start(with dependency: Dependency)
}

open class BaseCoordinator<Root> {
    public let root: Root
    
    public init(root: Root) {
        self.root = root
    }
}
