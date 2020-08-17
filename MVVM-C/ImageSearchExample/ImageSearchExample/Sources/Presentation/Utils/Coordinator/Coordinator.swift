//
//  Coordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

struct Coordinator {
    func start(flow: ViewControllerFlowType, presentStyle style: PresentStyle, animated: Bool) {
        style.present(targetViewController: flow.viewController, animated: animated)
    }
}
