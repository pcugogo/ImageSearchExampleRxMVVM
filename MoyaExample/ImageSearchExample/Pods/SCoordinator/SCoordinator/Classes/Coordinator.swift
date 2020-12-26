//
//  Coordinator.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/22.
//

import UIKit

open class Coordinator<RootView: RootViewType>: CoordinatorType, ParentCoordinator {
    
    public unowned var rootView: RootView
    unowned var parent: ParentCoordinator!
    
    var childrens: [String:CoordinatorType] = [:]
    
    
    public init(rootView: RootView) {
        self.rootView = rootView
    }
    
    func start(with parentCoordinator: ParentCoordinator) {
        parent = parentCoordinator
        let childKey = String(describing: Self.self)
        parent.childrens[childKey] = self
    }
    
    open func navigate(to route: Route) {}
    
    public func end(type: EndType) {
        switch type {
        case let .dismiss(animated, completion):
            childrens.removeValue(forKey: String(describing: Self.self))
            if let viewController = rootView as? UIViewController {
                viewController.dismiss(animated: animated, completion: completion)
            } else {
                NSLog("ERROR: - The RootView of **\(String(describing: Self.self))** is not a UIViewController type.")
            }
        case let .popView(animated):
            if let navigationController = rootView as? UINavigationController {
                navigationController.popViewController(animated: animated)
            } else {
                NSLog("ERROR: - The RootView of **\(String(describing: Self.self))** is not a UINavigationController type.")
            }
        }
    }
}
