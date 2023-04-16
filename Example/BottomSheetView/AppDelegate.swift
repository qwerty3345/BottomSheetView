//
//  AppDelegate.swift
//  BottomSheetView
//
//  Created by qwerty3345 on 04/15/2023.
//  Copyright (c) 2023 qwerty3345. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.rootViewController = MainViewController()

    return true
  }

}

