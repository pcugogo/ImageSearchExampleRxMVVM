//
//  PresentStyle.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 14/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

enum PresentStyle {
    case root(window: UIWindow)
    case push(navigationController: UINavigationController)
    case modal(senderViewController: UIViewController)
    
    func present(targetViewController: UIViewController, animated: Bool) {
        switch self {
        case .root(let window):
            window.rootViewController = targetViewController
        case .push(let navigationController):
            navigationController.pushViewController(targetViewController, animated: animated)
        case .modal(let senderViewController):
            senderViewController.present(targetViewController, animated: animated)
        }
    }
}
