//
//  Aurora.swift
//  Driver
//
//  Created by lizhihui on 2021/5/24.
//

import Foundation

extension JavaScript {
    enum Aurora: Scriptable {
        enum Method: String, MethodAble {
            case auth = "window.jgiosLoginCallBack"
            var name: String {
                switch self {
                case .auth: return "jsLoginWithJG"
                }
            }
        }

        var status: Int {
            switch self {
            case .networkFailed: return -2
            case .authorization(let info): return info.code
            }
        }

        var message: String {
            switch self {
            case .networkFailed: return "请安装sim卡或者开启流量"
            case .authorization(let info): return info.message
            }
        }

        var data: [String: String?] {
            switch self {
            case .networkFailed: return [:]
            case .authorization(let info): return ["token": info.token, "operator": info.operator]
            }
        }

        var method: Method {
            switch self {
            case .networkFailed,
                 .authorization:
                return .auth
            }
        }

        case networkFailed
        case authorization((code: Int, token: String, operator: String, message: String))
    }
}
