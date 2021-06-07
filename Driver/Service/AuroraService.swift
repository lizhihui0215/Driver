//
// Created by lizhihui on 2021/5/1.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation
import UIKit

class AuroraService: NSObject, AppService {
    override init() {
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let config = JVAuthConfig()
        config.appKey = app.aurora.appId
        #if DEBUG
            config.authBlock = { info in
                guard let info = info, let code = info["code"], let content = info["content"] else { return }
                log.debug("aurora auth result: \(code) content: \(content)")
            }
            JVERIFICATIONService.setDebug(true)
        #endif
        JVERIFICATIONService.setup(with: config)
        return true
    }
}
