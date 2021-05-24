//
//  WKWebViewController+JavascriptInteraction.swift
//  Driver
//
//  Created by lizhihui on 2021/5/24.
//

import Foundation
import UIKit
import WebKit

extension WKWebViewController: WKScriptMessageHandler {
    enum AuthMethod {
        case wechat
        case aurora
    }

    enum AuthState: String {
        case `default` = "huoda_wx_oauth_state"
    }

    enum AuthScope: String {
        case `default` = "snsapi_userinfo"
    }

    func auth(_ method: AuthMethod) {
        switch method {
        case .wechat: wechatAuth()
        case .aurora: auroraAuth()
        }
    }

    func auroraAuth() {
        guard JVERIFICATIONService.checkVerifyEnable() else {
            log.debug("aurora is not eligible on current network")
            evaluateJavaScript(for: .networkFailed)

            return
        }

        JVERIFICATIONService.getAuthorizationWith(self) { [weak self] info in
            log.debug("aurora authorization result: \(info ?? [:])")
            guard let self = self else { return }
            guard let info = info else { return }
            let code = info["code"] as? Int ?? -1
            let token = info["loginToken"] as? String ?? ""
            let `operator` = info["operator"] as? String ?? ""
            let message = info["content"] as? String ?? ""
            let parameter = (code: code, token: token, operator: `operator`, message: message)
            `self`.evaluateJavaScript(for: .authorization(parameter))
        }
    }

    func wechatAuth(state: AuthState = .default, scope: AuthScope = .default) {
        guard WXApi.isWXAppInstalled() else {
            alert(title: "提示", message: "您未安装微信,暂不能使用微信登录")
            return
        }

        let request = SendAuthReq()
        request.state = state.rawValue
        request.scope = scope.rawValue

        WXApi.send(request) {
            log.debug($0 ? "success" : "failure")
        }
    }

    @IBAction func unwindFromScan(sender: UIStoryboardSegue) {
        switch sender.source {
        case let source as ScanViewController:
            let metadataObject = source.viewModel.metadataObject
            evaluateJavaScript(for: .scan(code: metadataObject?.messageString))
        default: break
        }
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case JavaScript.System.Method.scan.name:
            perform(segue: StoryboardSegue.Main.toScan)
        case JavaScript.System.Method.tel.name:
            guard let phone = message.body as? String else { break }
            UIApplication.shared.tel(phone: phone)
        case JavaScript.System.Method.pasteBoard.name: break
        case JavaScript.System.Method.pasteBoardResponse.name: break
        case JavaScript.Aurora.Method.auth.name:
            auth(.aurora)
        case JavaScript.Wechat.Method.auth.name:
            auth(.wechat)
        case JavaScript.Map.Method.baidu.name:
            guard let body = message.body as? [String: String] else { break }
            let name = body["name"] ?? ""
            let longitude = body["longitude"] ?? ""
            let laitude = body["laitude"] ?? ""
            UIApplication.shared.bdapp(name: name, longitude: longitude, laitude: laitude)
        case JavaScript.Map.Method.amap.name:
            guard let body = message.body as? [String: String] else { break }
            let name = body["name"] ?? ""
            let longitude = body["longitude"] ?? ""
            let laitude = body["laitude"] ?? ""
            UIApplication.shared.amap(name: name, longitude: longitude, laitude: laitude)
        default: break
        }
    }
}
