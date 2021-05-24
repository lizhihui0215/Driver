//
//  Wechat.swift
//  Driver
//
//  Created by lizhihui on 2021/5/24.
//

import Foundation

extension JavaScript {
    enum Wechat: Scriptable {
        case auth(response: SendAuthResp)
        var status: Int {
            switch self {
            case .auth(let response): return Int(response.errCode)
            }
        }

        var message: String {
            switch self {
            case .auth(let response):
                switch WXErrCode(rawValue: response.errCode) {
                case WXSuccess: return "成功"
                case WXErrCodeCommon: return "普通错误类型"
                case WXErrCodeUserCancel: return "用户点击取消并返回"
                case WXErrCodeSentFail: return "发送失败"
                case WXErrCodeAuthDeny: return "授权失败"
                case WXErrCodeUnsupport: return "微信不支持"
                default: return "unknow"
                }
            }
        }

        var data: [String: String?] {
            switch self {
            case .auth(let response): return ["code": response.code,
                                              "state": response.state,
                                              "lang": response.lang,
                                              "country": response.country]
            }
        }

        var method: Method {
            .auth
        }

        enum Method: String, MethodAble {
            case auth = "window.wxiosLoginCallBack"

            var name: String {
                switch self {
                case .auth: return "jsLoginOAuth"
                }
            }
        }
    }
}
