//
//  BaseCoordinator.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/28.
//

import Foundation

open class BaseCoordinator<RootView: RootViewType>: CoordinatorType, ParentCoordinator {
    
    public unowned var rootView: RootView!
    internal unowned var parent: ParentCoordinator!
    
    public var childrens: [String:CoordinatorType] = [:]
    
    open func navigate(to route: Route) {}
    
    public func end(type: EndType) {
        switch type {
        case let .dismiss(animated, completion):
            if let viewController = rootView as? UIViewController {
                viewController.dismiss(animated: animated, completion: completion)
                self.parent.childrens.removeValue(forKey: String(describing: Self.self))
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
