//
//  SceneDelegate.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 24/12/25.
//

import Foundation
import UIKit

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        guard let quickAction = QuickAction(shortcutItem: shortcutItem) else {
            completionHandler(false)
            return
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.quickActionToHandle = quickAction
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("ProcessQuickAction"),
            object: nil
        )
        
        completionHandler(true)
    }
}
