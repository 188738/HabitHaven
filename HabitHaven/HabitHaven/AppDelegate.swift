//
//  AppDelegate.swift
//  HabitHaven
//
//  Created by Kousthub Sai Ganugapati on 1/2/25.
//

import SwiftUI
import FirebaseCore

// AppDelegate class for Firebase setup
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
