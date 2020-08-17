//
//  ViewControllerFlow.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

protocol ViewControllerFlowType {
    var viewController: UIViewController { get }
}

protocol ViewControllerTargetable {
    associatedtype Target
    var target: Target { get }
    init(target: Target)
}

typealias ViewControllerFlow = ViewControllerFlowType & ViewControllerTargetable
