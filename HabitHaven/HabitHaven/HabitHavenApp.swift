//
//  HabitHavenApp.swift
//  HabitHaven
//
//  Created by Kousthub Sai Ganugapati on 1/1/25.
//

import SwiftUI

@main
struct HabitHavenApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            TitleView()
        }
    }
}
