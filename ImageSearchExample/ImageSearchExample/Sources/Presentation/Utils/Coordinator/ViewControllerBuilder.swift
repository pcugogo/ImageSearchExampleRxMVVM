//
//  ViewControllerBuilder.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

protocol ViewControllerTargetable {
    associatedtype Target
    init(target: Target, dependency: Container)
}

typealias ViewControllerBuilder = BaseBuilder & ViewControllerTargetable
