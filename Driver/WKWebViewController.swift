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

    @IBAction func toScanTapped(_ sender: UIButton) {
        perform(segue: StoryboardSegue.Main.toScan)
    }

    @IBAction func toJGLoginTapped(_ sender: UIButton) {
        auth(.aurora)
    }

    @IBAction func toWXLoginTapped(_ sender: UIButton) {
        auth(.wechat)
    }

    @IBAction func toBaiduMapTapped(_ sender: UIButton) {
        UIApplication.shared.bdapp(name: "25", longitude: "108.954163", laitude: "34.278155")
    }

    @IBAction func toGaodeMapTapped(_ sender: UIButton) {
        UIApplication.shared.amap(name: "25", longitude: "108.954163", laitude: "34.278155")
    }

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

    // 全屏模式
    func setupAuroraAuthrizationPage() {
        let auroraAuthUIConfiguration = AurorUIFactory.makeUIConfiguration()
        JVERIFICATIONService.customUI(with: auroraAuthUIConfiguration) { _ in
            // 自定义view, 加到customView上
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        wechatService?.delegate = self
        registerJavaScriptMethods()
        setupWKWebView()
        setupAuroraAuthrizationPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let destination as ScanViewController:
            destination.viewModel = ScanViewModel()

        default: super.prepare(for: segue, sender: sender)
        }
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
        add(self, system: .scan)
        add(self, system: .tel)
        add(self, aurora: .auth)
        add(self, wechat: .auth)
        add(self, system: .pasteBoard)
        add(self, system: .pasteBoardResponse)
        add(self, map: .baidu)
        add(self, map: .amap)
    }

    private func removeJavascriptMethods() {
        removeScriptMessageHandler(system: .scan)
        removeScriptMessageHandler(system: .tel)
        removeScriptMessageHandler(system: .pasteBoardResponse)
        removeScriptMessageHandler(aurora: .auth)
        removeScriptMessageHandler(wechat: .auth)
        removeScriptMessageHandler(map: .baidu)
        removeScriptMessageHandler(map: .amap)
    }

    func add(_ scriptMessageHandler: WKScriptMessageHandler, system method: JavaScript.System.Method) {
        webView.configuration.userContentController.add(self, name: method.name)
    }

    func add(_ scriptMessageHandler: WKScriptMessageHandler, wechat method: JavaScript.Wechat.Method) {
        webView.configuration.userContentController.add(self, name: method.name)
    }

    func add(_ scriptMessageHandler: WKScriptMessageHandler, aurora method: JavaScript.Aurora.Method) {
        webView.configuration.userContentController.add(self, name: method.name)
    }

    func add(_ scriptMessageHandler: WKScriptMessageHandler, map method: JavaScript.Map.Method) {
        webView.configuration.userContentController.add(self, name: method.name)
    }

    func removeScriptMessageHandler(map method: JavaScript.Map.Method) {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: method.name)
    }

    func removeScriptMessageHandler(system method: JavaScript.System.Method) {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: method.name)
    }

    func removeScriptMessageHandler(wechat: JavaScript.Wechat.Method) {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: wechat.name)
    }

    func removeScriptMessageHandler(aurora: JavaScript.Aurora.Method) {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: aurora.name)
    }

    deinit {
        removeJavascriptMethods()
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

extension WKWebViewController: WechatServiceDelegate {
    func service(_ service: WechatService, didReceivedMessageRequest: ShowMessageFromWXReq) {}

    func service(_ service: WechatService, didReceivedLaunchWXRequest: LaunchFromWXReq) {}

    func service(_ service: WechatService, didReceivedMessageResponse: SendMessageToWXResp) {}

    func service(_ service: WechatService, didReceivedAuthResponse: SendAuthResp) {
        log.debug("wechat service did received auth response: \(didReceivedAuthResponse)")
        evaluateJavaScript(for: .auth(response: didReceivedAuthResponse))
    }

    func service(_ service: WechatService, didReceivedAddCardResponse: AddCardToWXCardPackageResp) {}

    func service(_ service: WechatService, didReceivedChooseCardResponse: WXChooseCardResp) {}

    func service(_ service: WechatService, didReceivedChooseInvoiceResponse: WXChooseInvoiceResp) {}

    func service(_ service: WechatService, didReceivedSubscribeMsgResponse: WXChooseInvoiceResp) {}

    func service(_ service: WechatService, didReceivedLaunchMiniProgram: WXLaunchMiniProgramResp) {}

    func service(_ service: WechatService, didReceivedInvoiceAuthInsertResponse: WXInvoiceAuthInsertResp) {}

    func service(_ service: WechatService, didReceivedNonTaxpayResponse: WXNontaxPayResp) {}

    func service(_ service: WechatService, didReceivedPayInsuranceResponse: WXPayInsuranceResp) {}
}

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
