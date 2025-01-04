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
        
        let searchViewControllerFactory = SearchViewControllerFactory()
        let searchViewController = searchViewControllerFactory.createViewController()
        
        window.rootViewController = searchViewController
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
}
