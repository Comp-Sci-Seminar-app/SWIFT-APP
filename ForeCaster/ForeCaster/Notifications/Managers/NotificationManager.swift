import Foundation
import UserNotifications
import CoreLocation

//Sets the identifiers used to group notifications by type
//Each type sets themselves in their switch area where they are made
enum NotificationManagerConstants {
    static let timeBasedNotificationThreadId =
        "TimeBasedNotificationThreadId"
    static let calendarBasedNotificationThreadId =
        "CalendarBasedNotificationThreadId"
    static let locationBasedNotificationThreadId =
        "LocationBasedNotificationThreadId"
}

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    @Published var settings: UNNotificationSettings?
    
    //Function that handles requesting authorization for sending notifications
    //It will only ask once DON'T SAY NO
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
                self.fetchNotificationSettings()
                completion(granted)
            }
    }
    
    func fetchNotificationSettings() {
        //Gets the notification settings that are set in the app
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    //Creats a notification and takes a task object as an input
    //There are 3 types of notifications time intervale, calender date, and location
    func scheduleNotification(task: Task) {
        //Fills how the notification will appear
        let content = UNMutableNotificationContent()
        content.title = task.name
        content.body = "Weather Update!"
        
        //Allows the app to access content from notification category when the user interacts with the notification
        content.categoryIdentifier = "OrganizerPlusCategory"
        let taskData = try? JSONEncoder().encode(task)
        if let taskData = taskData {
            content.userInfo = ["Task": taskData]
        }
        
        //Checks if the type of notification is a valid type
        //Also checks for if the notification has to repeat
        var trigger: UNNotificationTrigger?
        
        //Sets each type of notification and gives them a type based on what they are being set with or for.
        switch task.reminder.reminderType {
        
        //Time Interval notification
        case .time:
            content.threadIdentifier = NotificationManagerConstants.timeBasedNotificationThreadId
            if let timeInterval = task.reminder.timeInterval {
                trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: timeInterval,
                    repeats: task.reminder.repeats)
            }
            
        //Calender date notification
        case .calendar:
            content.threadIdentifier = NotificationManagerConstants.timeBasedNotificationThreadId
            if let date = task.reminder.date {
                trigger = UNCalendarNotificationTrigger(
                    dateMatching: Calendar.current.dateComponents(
                        [.day, .month, .year, .hour, .minute],
                        from: date),
                    repeats: task.reminder.repeats)
            }
            
        //Location based notification
        case .location:
            content.threadIdentifier = NotificationManagerConstants.timeBasedNotificationThreadId
            //Checks for location permission
            guard CLLocationManager().authorizationStatus == .authorizedWhenInUse else {
                return
            }
            //Checks for location data
            if let location = task.reminder.location {
                //Sets latitude, longitude, and radius size for location and can be set to send the notification if you enter or exit the area
                //Radius is in meters
                let center = CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude)
                let region = CLCircularRegion(
                    center: center,
                    radius: location.radius,
                    identifier: task.id)
                trigger = UNLocationNotificationTrigger(
                    region: region,
                    repeats: task.reminder.repeats)
            }
        }
        
        //Creats the notification request
        if let trigger = trigger {
            let request = UNNotificationRequest(
                identifier: task.id,
                content: content,
                trigger: trigger)
            //Schedules the notification with the error for being if there is an error scheduling
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    //Removes a notification that you have scheduled
    func removeScheduledNotification(task: Task) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [task.id])
    }
}
