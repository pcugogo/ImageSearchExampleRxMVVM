//
//  Coordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

struct Coordinator {
    static func start(flow: ViewControllerFlowType,
                      presentStyle presenter: PresentStyle,
                      animated: Bool) {
        presenter.present(targetViewController: flow.viewController, animated: animated)
    }
}
