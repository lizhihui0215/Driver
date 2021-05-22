//
//  ViewController.swift
//  Driver
//
//  Created by lizhihui on 2021/5/21.
//

import Gifu
import PKHUD
import UIKit
import WebKit

class WKWebViewController: UIViewController {
    @IBOutlet var webView: WKWebView!

    lazy var preference: WKPreferences = {
        let preference = WKPreferences()
        preference.minimumFontSize = 0
        preference.javaScriptEnabled = true
        preference.javaScriptCanOpenWindowsAutomatically = true
        return preference
    }()

    lazy var configuration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preference
        return configuration
    }()

    lazy var userContentController: WKUserContentController = {
        let userContentController = WKUserContentController()

        return userContentController
    }()

    lazy var request: URLRequest = {
        let request = URLRequest(url: app.webURL)
        return request
    }()

    var wechatService: WechatService? {
        UIApplication.shared.service()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        wechatService?.delegate = self
        setupWKWebView()
        registerJavaScriptMethods()
    }

    private func setupWKWebView() {
        webView.load(request)
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = false
    }

    private func registerJavaScriptMethods() {
        add(self, method: .scan)
        add(self, method: .tel)
        add(self, aurora: .auth)
        add(self, wechat: .auth)
    }

    private func removeJavascriptMethods() {
        removeScriptMessageHandler(method: .scan)
        removeScriptMessageHandler(method: .tel)
        removeScriptMessageHandler(aurora: .auth)
        removeScriptMessageHandler(wechat: .auth)
    }

    func add(_ scriptMessageHandler: WKScriptMessageHandler, method: JavaScript.Method) {
        userContentController.add(self, name: method.name)
    }

    func add(_ scriptMessageHandler: WKScriptMessageHandler, wechat method: JavaScript.Wechat.Method) {
        userContentController.add(self, name: method.name)
    }

    func add(_ scriptMessageHandler: WKScriptMessageHandler, aurora method: JavaScript.Aurora.Method) {
        userContentController.add(self, name: method.name)
    }

    func removeScriptMessageHandler(method: JavaScript.Method) {
        userContentController.removeScriptMessageHandler(forName: method.name)
    }

    func removeScriptMessageHandler(wechat: JavaScript.Wechat.Method) {
        userContentController.removeScriptMessageHandler(forName: wechat.name)
    }

    func removeScriptMessageHandler(aurora: JavaScript.Aurora.Method) {
        userContentController.removeScriptMessageHandler(forName: aurora.name)
    }

    deinit {
        removeJavascriptMethods()
    }
}

extension WKWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case JavaScript.Method.scan.name: break
        case JavaScript.Method.tel.name: break
        case JavaScript.Method.scanSuccess.name: break
        case JavaScript.Aurora.Method.auth.name: break
        case JavaScript.Wechat.Method.auth.name: break
        default: break
        }
    }
}

extension WKWebViewController: WKUIDelegate {}

extension WKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        GIFHUD.shared.show()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        GIFHUD.shared.hide()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        GIFHUD.shared.show(.error)
        log.debug("web view did fail provisional navigation with error: \(error)")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        GIFHUD.shared.show(.error)
        log.debug("web view did fail navigation with error: \(error)")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust,
              challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
        else {
            completionHandler(.useCredential, nil)
            return
        }

        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    }
}

extension WKWebViewController {
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
            let code = info["code"] as? String ?? ""
            let token = info["loginToken"] as? String ?? ""
            let `operator` = info["operator"] as? String ?? ""
            let message = info["content"] as? String ?? ""
            let parameter = (code: code, token: token, operator: `operator`, message: message)
            `self`.evaluateJavaScript(for: .authorization(parameter))
        }
    }
}

extension WKWebViewController: WechatServiceDelegate {}

extension WKWebViewController: WechatAuthAPIDelegate {
    open func onAuthGotQrcode(_ image: UIImage) {
        log.debug("wechat on auth got QR code: ", context: image)
    }

    open func onQrcodeScanned() {
        log.debug("wechat on QR code scanned")
    }

    open func onAuthFinish(_ errCode: Int32, authCode: String?) {
        let debugLog = NSMutableString(string: "wechat on auth finished error code: \(AuthErrCode(rawValue: errCode))")

        if let authCode = authCode {
            debugLog.append("auth code: \(authCode)")
        }

        log.debug(debugLog)
    }
}
