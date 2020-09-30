//
//  Storyboard.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 13/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    
    func instantiate(bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

extension UIStoryboard {
    func instantiateViewController<T>(type: T.Type) -> T? {
        self.instantiateViewController(withIdentifier: String(describing: type.self)) as? T
    }
}
