//
//  PresentStyle.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/10.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

enum PresentStyle {
    case root(UIWindow)
    case show(UINavigationController)
    case modal(
            modalPresentationStyle: UIModalPresentationStyle,
            modalTransitionStyle: UIModalTransitionStyle,
            UIViewController
         )
    
    var currentViewController: UIViewController? {
        switch self {
        case .root(let window):
            return window.rootViewController
        case .show(let navigationController):
            return navigationController.viewControllers.last
        case .modal(_, _, let viewController):
            return viewController
        }
    }
    
    func present(targetViewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        switch self {
        case .root(let window):
            window.rootViewController = targetViewController
        case .show(let navigationController):
            navigationController.pushViewController(targetViewController, animated: animated)
        case .modal(let presentationStyle, let transitionStyle, let viewController):
            targetViewController.modalPresentationStyle = presentationStyle
            targetViewController.modalTransitionStyle = transitionStyle
            viewController.present(targetViewController, animated: animated, completion: completion)
        }
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        switch self {
        case .root:
            break
        case .show(let navigationController):
            navigationController.popViewController(animated: animated)
        case .modal(_, _, let viewController):
            viewController.dismiss(animated: animated, completion: completion)
        }
    }
}
