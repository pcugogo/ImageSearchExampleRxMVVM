//
//  UIViewController+instantiateFromStoryboard.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/09.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func instantiateFromStoryboard(name: StoryboardName = .main) -> Self {
        return name
            .instantiateStoryboard()
            .instantiateViewController(withIdentifier: String(describing: Self.self)) as! Self
    }
}
