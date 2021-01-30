//
//  ParentCoordinator.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/25.
//

import Foundation

public protocol ParentCoordinator: AnyObject {
    var rootCoordinator: ParentCoordinator? { get }
    var childrens: [String:CoordinatorType] { get set }
}

