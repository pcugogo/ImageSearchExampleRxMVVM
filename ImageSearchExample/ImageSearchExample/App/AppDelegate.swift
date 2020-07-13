//
//  AppDelegate.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let searchViewModel: SearchViewModelType = SearchViewModel()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let searchNavigationController = storyboard.instantiateViewController(withIdentifier: "SearchNavigationController") as? UINavigationController {
            if var searchViewController = searchNavigationController.viewControllers.first as? SearchViewController {
                searchViewController.bind(viewModel: searchViewModel)
                window?.rootViewController = searchViewController
            } else {
                fatalError()
            }
        } else {
            fatalError()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}
