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

    func tel(phone: String, completionHandler completion: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: "telprompt://\(phone)") else { return }
        open(url, completionHandler: completion)
    }

    func bdapp(location: (longitude: String, laitude: String), completionHandler completion: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: "baidumap://map/navi?location=40.057023,116.307852&coord_type=bd09ll&type=BLK&src=ios.baidu.openAPIdemo") else { return }
        open(url, completionHandler: completion)
    }

    func amap(poiname: String, poiid: String, lat: String, lon: String, completionHandler completion: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: "iosamap://navi?sourceApplication=huoda&poiname=fangheng&poiid=BGVIS&lat=36.547901&lon=104.258354&dev=1&style=2") else { return }
        open(url, completionHandler: completion)
    }
}
