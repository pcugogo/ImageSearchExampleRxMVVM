//
//  CoordinatorType.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 13/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

protocol Coordinatable {
    associatedtype Target
    func start(target: Target, presentStyle style: PresentStyle, animated: Bool)
}

