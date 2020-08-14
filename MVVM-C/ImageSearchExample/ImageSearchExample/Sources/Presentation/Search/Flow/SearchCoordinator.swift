//
//  SearchCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 13/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class SearchCoordinator: Coordinatable {
    enum Target {
        case detailImage(imageURLString: String)
        
        var viewController: UIViewController {
            var maker: ViewControllerMaker
            switch self {
            case .detailImage(let imageURLString):
                maker = DetailImageMaker(imageURLString: imageURLString)
            }
            return maker.makeViewController()
        }
    }
    
    func start(target: Target, presentStyle style: PresentStyle, animated: Bool) {
        style.present(targetViewController: target.viewController, animated: animated)
    }
}
