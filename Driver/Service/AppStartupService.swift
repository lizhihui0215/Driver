//
// Created by lizhihui on 2021/5/4.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation

class AppStartupService: NSObject, AppService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Appearance.shared.launch()
        return true
    }
}
