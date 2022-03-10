//
//  backend.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 3/2/22.
//

import SwiftUI
import UIKit
import BackgroundTasks

//allows me to set the back button to invisible so I can add a custom image behind it. Also copy and pasted from stack overflow
class Theme {
    static func navigationBarColors(background : UIColor?,
                                    titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .black
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}
extension Color{
    static let customBlue = Color("CustomBlue")
    static let customGray = Color("CustomGray")
    
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Register Background task here
        registerBackgroundTasks()
        return true
    }
    
    func registerBackgroundTasks() {
        // Declared at the "Permitted background task scheduler identifiers" in info.plist
        let backgroundAppRefreshTaskSchedulerIdentifier = "Smartester-People-CO.ForeCaster"
        let backgroundProcessingTaskSchedulerIdentifier = "Smartester-People-CO.ForeCaster"
        
        // Use the identifier which represents your needs
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundAppRefreshTaskSchedulerIdentifier, using: nil) { (task) in
            print("BackgroundAppRefreshTaskScheduler is executed NOW!")
            print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
            task.expirationHandler = {
                task.setTaskCompleted(success: false)
            }
            
            // Do some data fetching and call setTaskCompleted(success:) asap!
            let isFetchingSuccess = true
            task.setTaskCompleted(success: isFetchingSuccess)
        }
        var window: UIWindow?
        
        func applicationDidEnterBackground(_ application: UIApplication) {
            submitBackgroundTasks()
        }
        
        func submitBackgroundTasks() {
            // Declared at the "Permitted background task scheduler identifiers" in info.plist
            let backgroundAppRefreshTaskSchedulerIdentifier = "Smartester-People-CO.ForeCaster"
            let timeDelay = 10.0
            
            do {
                let backgroundAppRefreshTaskRequest = BGAppRefreshTaskRequest(identifier: backgroundAppRefreshTaskSchedulerIdentifier)
                backgroundAppRefreshTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: timeDelay)
                try BGTaskScheduler.shared.submit(backgroundAppRefreshTaskRequest)
                print("Submitted task request")
            } catch {
                print("Failed to submit BGTask")
            }
        }
    }
}
