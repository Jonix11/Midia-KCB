//
//  AppDelegate.swift
//  Midia
//
//  Created by Jon Gonzalez on 26/02/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let homeViewController  = tabBarController.viewControllers?.first as? HomeViewController,
            let searchViewController = tabBarController.viewControllers?[1] as? SearchViewController else {
                fatalError("Wrong initial setup")
        }
        let currentMediaItemProvider = MediaItemProvider(withMediaItemKind: .book)
        homeViewController.mediaItemProvider = currentMediaItemProvider
        searchViewController.mediaItemProvider = currentMediaItemProvider
        
        return true
    }

}

