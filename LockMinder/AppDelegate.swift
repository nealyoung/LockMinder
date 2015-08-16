//
//  AppDelegate.swift
//  LockMinder
//
//  Created by Nealon Young on 8/6/15.
//  Copyright © 2015 Nealon Young. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds);
        
        customizeAppearance()
        
        var reminderSelectionViewController = ReminderSelectionViewController()
        var navigationController = UINavigationController(rootViewController: reminderSelectionViewController)
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible();
        
        return true
    }

    func customizeAppearance() {
        self.window?.tintColor = UIColor.purpleApplicationColor()
        
        let navigationBarTitleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont.mediumApplicationFont(19.0)
        ]
        
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = navigationBarTitleTextAttributes
        UINavigationBar.appearance().tintColor = .whiteColor()
        UINavigationBar.appearance().barTintColor = .purpleApplicationColor()
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
}

