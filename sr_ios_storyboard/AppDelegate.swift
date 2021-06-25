import Foundation
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard let configures = Bundle.main.infoDictionary else {
            fatalError("Can't read Plist file")
        }
        
        guard let apiUrl = configures["api_url"] as? String else {
            fatalError("api_url not found")
        }
        
        API.shared.setAPIURL(apiUrl: apiUrl)
        let environment = ProcessInfo.processInfo.environment
        if let testcase = environment.first(where: { $0.key == "testcase" }) {
            let apiRequestMock = APIRequestMock(testcase.value)
            API.shared.setAPIRequest(apiRequestMock)
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        }
        if let token = UserDefaults.standard.string(forKey: "token") {
            API.shared.setToken(token)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

