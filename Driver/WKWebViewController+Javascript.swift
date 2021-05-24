//
//  WKWebViewController+Javascript.swift
//  Driver
//
//  Created by lizhihui on 2021/5/24.
//

import Foundation
import UIKit

extension WKWebViewController {
    func evaluateJavaScript(for wechat: JavaScript.Wechat) {
        webView.evaluateJavaScript(wechat.script()) { result, error in
            let debugLog = NSMutableString(string: "wechat javaScript evaluated")

            if let result = result {
                debugLog.append("result: \(result)")
            }

            if let error = error {
                debugLog.append(", error: \(error)")
            }

            log.debug(debugLog)
        }
    }

    func evaluateJavaScript(for map: JavaScript.Map) {
        webView.evaluateJavaScript(map.script()) { result, error in
            let debugLog = NSMutableString(string: "wechat javaScript evaluated")

            if let result = result {
                debugLog.append("result: \(result)")
            }

            if let error = error {
                debugLog.append(", error: \(error)")
            }

            log.debug(debugLog)
        }
    }

    func evaluateJavaScript(for aurora: JavaScript.Aurora) {
        webView.evaluateJavaScript(aurora.script()) { result, error in
            let debugLog = NSMutableString(string: "aurora javaScript evaluated")

            if let result = result {
                debugLog.append("result: \(result)")
            }

            if let error = error {
                debugLog.append(", error: \(error)")
            }

            log.debug(debugLog)
        }
    }

    func evaluateJavaScript(for system: JavaScript.System) {
        webView.evaluateJavaScript(system.script()) { result, error in
            let debugLog = NSMutableString(string: "javaScript evaluated")

            if let result = result {
                debugLog.append("result: \(result)")
            }

            if let error = error {
                debugLog.append(", error: \(error)")
            }

            log.debug(debugLog)
        }
    }
}
