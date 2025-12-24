//
//  AppDelegate.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 24/12/25.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    var quickActionToHandle: QuickAction?
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            quickActionToHandle = QuickAction(shortcutItem: shortcutItem)
        }
        
        let sceneConfiguration = UISceneConfiguration(
            name: "Quick Action Scene",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
}
