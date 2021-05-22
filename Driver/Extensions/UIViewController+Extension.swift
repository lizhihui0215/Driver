//
// Created by ZhiHui.Li on 2021/4/16.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import PKHUD
import UIKit

extension UIViewController: Action {}

protocol Action: AnyObject {
    func alert(title: String?,
               message: String,
               defaultAction: UIAlertAction,
               otherAction: UIAlertAction?)

    func startLoadingIndicator()

    func stopLoadingIndicator()

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

extension Action {
    static var defaultActionAlertTitle: String {
        "OK"
    }

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        present(viewControllerToPresent, animated: flag, completion: nil)
    }

    func startLoadingIndicator() {
        HUD.show(.systemActivity)
    }

    func stopLoadingIndicator() {
        HUD.hide(animated: true)
    }

    var window: UIWindow? {
        UIApplication.shared.appDelegate.windowService?.window
    }

    func alert(message: String,
               defaultAction: UIAlertAction = Self.defaultAlertAction(),
               otherAction: UIAlertAction? = nil)
    {
        alert(title: nil, message: message, defaultAction: defaultAction, otherAction: otherAction)
    }

    func alert(title: String?, message: String) {
        alert(title: title, message: message, defaultAction: Self.defaultAlertAction(), otherAction: nil)
    }

    func alert(title: String?,
               message: String,
               defaultAction: UIAlertAction,
               otherAction: UIAlertAction?)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let otherAction = otherAction {
            alertController.addAction(otherAction)
        }

        alertController.addAction(defaultAction)
        present(alertController, animated: true)
    }

    static func defaultAlertAction(title: String = Self.defaultActionAlertTitle, dismissHandler: (() -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: title, style: .cancel) { _ in
            guard let handler = dismissHandler else { return }
            handler()
        }
    }

    func handler(error: Error) {}
}
