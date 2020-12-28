//
//  Coordinator.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/22.
//

import Foundation

open class Coordinator<RootView: RootViewType>: BaseCoordinator<RootView> {
    
    public init(rootView: RootView, parentCoordinator: ParentCoordinator) {
        super.init()
        self.rootView = rootView
        start(with: parentCoordinator)
    }
    
    private func start(with parentCoordinator: ParentCoordinator) {
        parent = parentCoordinator
        let childKey = String(describing: Self.self)
        parent.childrens[childKey] = self
    }
}
