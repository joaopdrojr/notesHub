//
//  notesHubApp.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 21/12/25.
//

import SwiftUI

@main
struct notesHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    @StateObject private var notesManager = NotesManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(notesManager)
                .onAppear {
                    handleQuickAction()
                }
                .onReceive(NotificationCenter.default.publisher(
                    for: UIApplication.willEnterForegroundNotification
                )) { _ in
                    handleQuickAction()
                }
                .onReceive(NotificationCenter.default.publisher(
                    for: NSNotification.Name("ProcessQuickAction")
                )) { _ in
                    handleQuickAction()
                }
        }
    }
    
    private func handleQuickAction() {
        guard let quickAction = appDelegate.quickActionToHandle else {
            return
        }
        
        appState.handle(quickAction)
        appDelegate.quickActionToHandle = nil
    }
}
