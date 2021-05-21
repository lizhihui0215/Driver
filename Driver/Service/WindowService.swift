//
// Created by lizhihui on 2021/5/4.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation

class WindowService: NSObject, AppService {
    enum Constants {
        static let TabConfiguration = "Tab Configuration"
        static let DefaultConfiguration = "Default Configuration"
    }

    var window: UIWindow?

    var launchStoryboardScenes: [String: StoryboardType.Type] = [StoryboardScene.Login.storyboardName: StoryboardScene.Login.self,
                                                                 StoryboardScene.Tab.storyboardName: StoryboardScene.Tab.self]

    init(window: UIWindow?) {
        self.window = window
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) { return true }
        let storyboardName = launchEntranceName()
        let type = launchStoryboardScenes[storyboardName]!
        window?.rootViewController = InitialSceneType(storyboard: type.self).instantiate()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: launchEntranceName(), sessionRole: connectingSceneSession.role)
    }

    func launchEntranceName() -> String {
        guard #available(iOS 13.0, *) else {
            return app.credential != nil ? StoryboardScene.Tab.storyboardName : StoryboardScene.Login.storyboardName
        }

        return app.credential != nil ? Constants.TabConfiguration : Constants.DefaultConfiguration
    }
}
