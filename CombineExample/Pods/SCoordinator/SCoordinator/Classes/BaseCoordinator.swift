//
//  BaseCoordinator.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/28.
//

import Foundation

open class BaseCoordinator<RootView: RootViewType>: CoordinatorType, ParentCoordinator {
    
    // Root View of the current coordinator.
    public unowned var rootView: RootView!
    // Childrens coordinator of the current coordinator.
    public var childrens: [String:CoordinatorType] = [:]
    // Root coordinator of the current coordinator.
    public weak var rootCoordinator: ParentCoordinator?
    // Parent coordinator of the current coordinator.
    internal weak var parent: ParentCoordinator?
    
    open func navigate(to route: Route) {}
    public func end() {}
}

