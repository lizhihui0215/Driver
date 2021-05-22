//
// Created by lizhihui on 2021/5/4.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var appDelegate: AppDelegate {
        // swiftlint:disable:next force_cast
        UIApplication.shared.delegate as! AppDelegate
    }

    func service<T: AppService>() -> T? {
        appDelegate.service()
    }
}
