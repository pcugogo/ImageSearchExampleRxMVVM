//
//  ImageSearchStep.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/09.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxFlow

enum ImageSearchStep: Step {
    case search
    case detailImage(imageURLString: String)
}
