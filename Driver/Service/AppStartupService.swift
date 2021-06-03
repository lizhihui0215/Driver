//
// Created by lizhihui on 2021/5/4.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation
import UIKit

class AppStartupService: NSObject, AppService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Appearance.shared.launch()
        PermissionManager.shared.requestAccess(for: .avCapture(.video))
        PermissionManager.shared.requestAccess(for: .photoLibrary)
        return true
    }
}
