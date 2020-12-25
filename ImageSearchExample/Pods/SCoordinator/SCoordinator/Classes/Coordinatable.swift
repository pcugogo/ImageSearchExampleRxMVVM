//
//  Coordinatable.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/22.
//

import Foundation

public protocol Coordinatable: AnyObject {
    var coordinator: CoordinatorType! { get set }
}

public extension Coordinatable {
    func setCoordinator(coordinator: CoordinatorType) {
        
        self.coordinator = coordinator
    }
}
