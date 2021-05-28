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

    func bdapp(name: String, longitude: String, laitude: String, completionHandler completion: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: "baidumap://map/navi?location=\(laitude),\(longitude)&coord_type=gcj02src=\(app.identifier)") else { return }

        guard canOpenURL(url) else {
            alert(message: "未找到对应的应用程序，请下载安装")
            return
        }

        guard [longitude, laitude, name].allSatisfy({ !$0.isEmpty }) else {
            alert(message: "目标地址不明确")
            return
        }

        open(url, completionHandler: completion)
    }

    func amap(name: String, longitude: String, laitude: String, completionHandler completion: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: "iosamap://navi?sourceApplication=\(app.identifier)&poiname=\(name)&poiid=BGVIS&lat=\(laitude)&lon=\(longitude)&dev=0&style=2") else { return }

        guard canOpenURL(url) else {
            alert(message: "未找到对应的应用程序，请下载安装")
            return
        }

        guard [longitude, laitude, name].allSatisfy({ !$0.isEmpty }) else {
            alert(message: "目标地址不明确")
            return
        }

        open(url, completionHandler: completion)
    }
}

extension UIApplication: Action {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        if let presentedViewController = window?.rootViewController?.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: completion)
        }

        window?.rootViewController?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
