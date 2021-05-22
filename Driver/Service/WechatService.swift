//
// Created by lizhihui on 2021/5/1.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation
import UIKit

@objc protocol WechatServiceDelegate: AnyObject {
    @objc optional func service(_ service: WechatService, didReceivedMessageRequest: ShowMessageFromWXReq)
    @objc optional func service(_ service: WechatService, didReceivedLaunchWXRequest: LaunchFromWXReq)
    @objc optional func service(_ service: WechatService, didReceivedMessageResponse: SendMessageToWXResp)
    @objc optional func service(_ service: WechatService, didReceivedAuthResponse: SendAuthResp)
    @objc optional func service(_ service: WechatService, didReceivedAddCardResponse: AddCardToWXCardPackageResp)
    @objc optional func service(_ service: WechatService, didReceivedChooseCardResponse: WXChooseCardResp)
    @objc optional func service(_ service: WechatService, didReceivedChooseInvoiceResponse: WXChooseInvoiceResp)
    @objc optional func service(_ service: WechatService, didReceivedSubscribeMsgResponse: WXChooseInvoiceResp)
    @objc optional func service(_ service: WechatService, didReceivedLaunchMiniProgram: WXLaunchMiniProgramResp)
    @objc optional func service(_ service: WechatService, didReceivedInvoiceAuthInsertResponse: WXInvoiceAuthInsertResp)
    @objc optional func service(_ service: WechatService, didReceivedNonTaxpayResponse: WXNontaxPayResp)
    @objc optional func service(_ service: WechatService, didReceivedPayInsuranceResponse: WXPayInsuranceResp)
}

class WechatService: NSObject, AppService {
    weak var delegate: WechatServiceDelegate?

    override init() {
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        WXApi.startLog(by: .normal) { debuglog in
            log.debug(debuglog)
        }

        WXApi.registerApp(app.wechat.appId, universalLink: app.wechat.universalLinks)

        #if DEBUG
            WXApi.checkUniversalLinkReady { step, result in
                log.debug("step: \(step) \n result: \(result)")
            }
        #endif

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        WXApi.handleOpen(url, delegate: self)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        WXApi.handleOpen(url, delegate: self)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
}

extension WechatService: WXApiDelegate {
    func onReq(_ req: BaseReq) {
        guard let delegate = delegate else { return }

        switch req {
        case let req as ShowMessageFromWXReq:
            delegate.service?(self, didReceivedMessageRequest: req)
        case let req as LaunchFromWXReq:
            delegate.service?(self, didReceivedLaunchWXRequest: req)
        default: break
        }
        log.debug("Wechat service did received request: \(req)")
    }

    func onResp(_ resp: BaseResp) {
        guard let delegate = delegate else { return }

        switch resp {
        case let resp as SendMessageToWXResp:
            delegate.service?(self, didReceivedMessageResponse: resp)
        case let resp as SendAuthResp:
            delegate.service?(self, didReceivedAuthResponse: resp)
        case let resp as AddCardToWXCardPackageResp:
            delegate.service?(self, didReceivedAddCardResponse: resp)
        case let resp as WXChooseCardResp:
            delegate.service?(self, didReceivedChooseCardResponse: resp)
        case let resp as WXChooseInvoiceResp:
            delegate.service?(self, didReceivedChooseInvoiceResponse: resp)
        case let resp as WXChooseInvoiceResp:
            delegate.service?(self, didReceivedSubscribeMsgResponse: resp)
        case let resp as WXLaunchMiniProgramResp:
            delegate.service?(self, didReceivedLaunchMiniProgram: resp)
        case let resp as WXInvoiceAuthInsertResp:
            delegate.service?(self, didReceivedInvoiceAuthInsertResponse: resp)
        case let resp as WXNontaxPayResp:
            delegate.service?(self, didReceivedNonTaxpayResponse: resp)
        case let resp as WXPayInsuranceResp:
            delegate.service?(self, didReceivedPayInsuranceResponse: resp)
        default: break
        }
        log.debug("Wechat service did received response: \(resp)")
    }
}
