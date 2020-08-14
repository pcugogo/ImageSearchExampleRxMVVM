//
//  AppCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 13/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

struct AppCoordinator: Coordinatable {
    enum Target {
        case search
        
        var viewController: UIViewController {
            let maker: ViewControllerMaker
            switch self {
            case .search:
                maker = SearchMaker(searchUseCase: SearchUseCase(apiService: APIService()))
            }
            return maker.makeViewController()
        }
    }
    func start(target: Target, presentStyle style: PresentStyle, animated: Bool) {
        style.present(targetViewController: target.viewController, animated: animated)
    }
}
