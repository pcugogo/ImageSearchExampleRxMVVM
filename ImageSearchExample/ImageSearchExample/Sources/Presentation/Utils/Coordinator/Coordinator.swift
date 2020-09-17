//
//  Coordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

struct Coordinator {
    static func start(target viewController: UIViewController, presentStyle presenter: PresentStyle, animated: Bool) {
        presenter.present(targetViewController: viewController, animated: animated)
    }
}
