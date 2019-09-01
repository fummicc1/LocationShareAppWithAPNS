import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var deviceToken: String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (_, _) in })
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.deviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(self.deviceToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let latitude = Double.random(in: 0...90)
        let longitude = Double.random(in: 0...180)
        
        let url = URL(string: "https://11443b5e.ngrok.io/location?latitude=\(latitude)&longitude=\(longitude)")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        }.resume()
    }
}

