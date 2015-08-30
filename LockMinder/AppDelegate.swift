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
        
        let reminderSelectionViewController = ReminderSelectionViewController()
        let navigationController = UINavigationController(rootViewController: reminderSelectionViewController)
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible();
        
        return true
    }

    func customizeAppearance() {
        self.window?.tintColor = UIColor.purpleApplicationColor()
        
        let navigationBarTitleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = navigationBarTitleTextAttributes
        UINavigationBar.appearance().tintColor = .whiteColor()
        UINavigationBar.appearance().barTintColor = .purpleApplicationColor()
        
        let barButtonItemTitleTextAttributes = [ NSFontAttributeName: UIFont.mediumApplicationFont(16.0) ]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonItemTitleTextAttributes, forState: .Normal)
    }
}

