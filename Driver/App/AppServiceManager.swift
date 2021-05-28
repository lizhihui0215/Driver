//
// Created by lizhihui on 2021/5/4.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation
import UIKit

protocol AppService: UIApplicationDelegate, UISceneDelegate {}

class AppServiceManager: UIResponder, UIApplicationDelegate {
    let window: UIWindow? = nil

    var windowService: WindowService? {
        service()
    }

    open var services: [AppService] { [] }

    func service<T: AppService>() -> T? {
        _services.first { $0 is T } as? T
    }

    func defaultSceneConfiguration(role: UISceneSession.Role) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: role)
    }

    lazy var _services: [AppService] = {
        self.services
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _services.allSatisfy {
            $0.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? true
        }
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        _services.allSatisfy {
            $0.application?(application, open: url, options: options) ?? true
        }
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        _services.allSatisfy {
            $0.application?(application, continue: userActivity, restorationHandler: restorationHandler) ?? true
        }
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        guard let windowService = windowService else {
            return defaultSceneConfiguration(role: connectingSceneSession.role)
        }

        return windowService.application(application, configurationForConnecting: connectingSceneSession, options: options)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        _services.forEach { $0.application?(application, didDiscardSceneSessions: sceneSessions) }
    }
}
