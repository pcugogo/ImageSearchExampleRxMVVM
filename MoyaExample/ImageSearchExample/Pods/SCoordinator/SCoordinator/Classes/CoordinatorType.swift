//
//  CoordinatorType.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/22.
//

import Foundation

public protocol CoordinatorType: AnyObject {
    func navigate(to route: Route)
    func end(type: EndType)
}
