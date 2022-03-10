import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        //Sets notification delegate upon opening the app
        configureUserNotifications()
        return true
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // UIApplication.backgroundFetchIntervalMinimum = 0s
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        // Period: 3600s = 1 hour
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)
        return true
    }
}
// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    //Determines how notifications will appear when the app is in the foreground
    //Currently set only to have a banner
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler(.banner)
    }
    //Makes itself the delegate for the the notification center
    private func configureUserNotifications() {
        UNUserNotificationCenter.current().delegate = self
        //Gives a few options that can be done when you tap on the notification
        let dismissAction = UNNotificationAction(
            identifier: "dismiss",
            title: "Dismiss",
            options: [])
        let markAsDone = UNNotificationAction(
            identifier: "markAsDone",
            title: "Mark As Done",
            options: [])
        //Defines the types of notifications the app can get
        let category = UNNotificationCategory(
            identifier: "OrganizerPlusCategory",
            actions: [dismissAction, markAsDone],
            intentIdentifiers: [],
            options: [])
        //Makes a new actionable notification
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    //Gets called when the user acts on the notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        //Decodes userInfo if the identifier is markAsDone
        if response.actionIdentifier == "markAsDone" {
            let userInfo = response.notification.request.content.userInfo
            if let taskData = userInfo["Task"] as? Data {
                if let task = try? JSONDecoder().decode(Task.self, from: taskData) {
                    //Removes the task from TaskManager when it's done
                    TaskManager.shared.remove(task: task)
                }
            }
        }
        completionHandler()
    }
}
func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
    let successCallback: (_ data: Data, _ error: Error) -> Void = { (data, error) in
        if let error = error {
            // There is an error
            completionHandler(.failed)
        } else if data.isEmpty {
            // No new data
            completionHandler(.noData)
        } else {
            // There is a new data set
            completionHandler(.newData)
        }
    }
    
    // Fetch data from your server, e.g. using Alamofire; Bear in mind, the duration of fetching causes a less frequency app refresh!
    fetchUpdates(callback: successCallback)
}
func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
    let successCallback: (_ data: Data, _ error: Error) -> Void = { (data, error) in
        if let error = error {
            // There is an error
            completionHandler(.failed)
        } else if data.isEmpty {
            // No new data
            completionHandler(.noData)
        } else {
            // There is a new data set
            completionHandler(.newData)
        }
    }
    
    // Fetch data from your server, e.g. using Alamofire; Bear in mind, the duration of fetching causes a less frequency app refresh!
    fetchUpdates(callback: successCallback)
}
func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
    let successCallback: (_ data: Data, _ error: Error) -> Void = { (data, error) in
        if let error = error {
            // There is an error
            completionHandler(.failed)
        } else if data.isEmpty {
            // No new data
            completionHandler(.noData)
        } else {
            // There is a new data set
            completionHandler(.newData)
        }
    }
    
    // Fetch data from your server, e.g. using Alamofire; Bear in mind, the duration of fetching causes a less frequency app refresh!
    fetchUpdates(callback: successCallback)
}
