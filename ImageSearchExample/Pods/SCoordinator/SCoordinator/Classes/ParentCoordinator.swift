//
//  ParentCoordinator.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/25.
//

import Foundation

protocol ParentCoordinator: AnyObject {
    var childrens: [String:CoordinatorType] { get set }
}
