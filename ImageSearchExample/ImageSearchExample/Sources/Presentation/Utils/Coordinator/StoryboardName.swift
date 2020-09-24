//
//  StoryboardName.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 13/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

enum StoryboardName: String {
    case main = "Main"
    
    func instantiateStoryboard(bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
