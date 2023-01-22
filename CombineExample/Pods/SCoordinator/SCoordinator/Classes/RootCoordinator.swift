//
//  RootCoordinator.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/28.
//

import Foundation

open class RootCoordinator<RootView: RootViewType>: BaseCoordinator<RootView> {
    
    public init(rootView: RootView) {
        super.init()
        self.rootView = rootView
    }
}
