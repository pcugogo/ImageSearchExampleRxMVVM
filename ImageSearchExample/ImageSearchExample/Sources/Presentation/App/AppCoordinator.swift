//
//  AppCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class AppCoordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let storyboard = StoryboardName.main.instantiateStoryboard()
        let navigationController = storyboard
            .instantiateViewController(withIdentifier: "SearchNavigationController") as! UINavigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let searchCoordinator = SearchCoordinator(navigationController: navigationController)
        let dependency = SearchCoordinator.Dependency(searchUseCase: SearchUseCase())
        searchCoordinator.start(with: dependency)
    }
}
