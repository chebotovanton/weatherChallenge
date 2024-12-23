//
//  AppDelegate.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let searchViewController = UIViewController()
        searchViewController.tabBarItem.title = "Search"
        searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let favouritesViewController = UIViewController()
        favouritesViewController.tabBarItem.title = "Favourites"
        favouritesViewController.tabBarItem.image = UIImage(systemName: "heart")
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [searchViewController, favouritesViewController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
}
