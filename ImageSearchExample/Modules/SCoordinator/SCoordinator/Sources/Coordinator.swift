//
//  Coordinator.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/13.
//

import UIKit

public typealias Coordinator<Root: AnyObject> = BaseCoordinator<Root> & CoordinatorType

public protocol CoordinatorType: AnyObject {
    func navigate(to route: Route)
}

open class BaseCoordinator<Root: AnyObject> {
    public weak var root: Root?
    
    public init(root: Root) {
        self.root = root
    }
}

public protocol Coordinatable: AnyObject {
    var coordinator: CoordinatorType! { get set }
}

extension Coordinatable where Self: AnyObject {
    public func retainCoordinator(_ coordinator: CoordinatorType) {
        self.coordinator = coordinator
    }
}
