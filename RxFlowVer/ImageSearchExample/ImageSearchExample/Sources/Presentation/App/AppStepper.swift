//
//  AppStepper.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/09.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxFlow
import RxCocoa

final class AppStepper: Stepper {
    var steps: PublishRelay<Step> = .init()
    
    var initialStep: Step {
        return ImageSearchStep.search
    }
}
