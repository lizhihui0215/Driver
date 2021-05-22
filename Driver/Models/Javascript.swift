//
//  Javascript.swift
//  Driver
//
//  Created by lizhihui on 2021/5/22.
//

import Foundation

protocol Scriptable {
    associatedtype Method: MethodAble
    var code: String { get }
    var message: String { get }
    var data: [String: String] { get }
    var body: JavaScript.Body { get }
    var method: Method { get }
    func script() -> String
}

extension Scriptable {
    func script() -> String {
        method.build(body: body)
    }

    var body: JavaScript.Body {
        JavaScript.Body(code: code, message: message, data: data)
    }
}

protocol MethodAble {
    var name: String { get }
    func build(body: JavaScript.Body) -> String
}

extension MethodAble where Self: RawRepresentable, Self.RawValue == String {
    func build(body: JavaScript.Body) -> String {
        var method = rawValue
        method.append("(")
        if !body.toJSONString().isEmpty { method.append(body.toJSONString()) }
        method.append(")")
        return method
    }
}

enum JavaScript: Scriptable {
    case scan
    case tel
    case scanSuccess(code: String)

    var code: String { "0" }

    var message: String { "" }

    var data: [String: String] {
        switch self {
        case .scanSuccess(let code): return ["code": code]
        default: return [:]
        }
    }

    var method: Method {
        switch self {
        case .scan: return .scan
        case .scanSuccess: return .scanSuccess
        case .tel: return .tel
        }
    }

    enum Method: String, MethodAble {
        case scan
        case tel
        case scanSuccess

        var name: String {
            switch self {
            case .scan: return "jsOpenScan"
            case .tel: return "jsOpenTel"
            case .scanSuccess: return "scanRsp"
            }
        }
    }
}

extension JavaScript {
    struct Body: Encodable {
        let code: String
        let message: String
        let data: [String: String]

        func toJSONString() -> String {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            guard let data = try? encoder.encode(self) else { return "" }

            return String(data: data, encoding: .utf8) ?? ""
        }
    }
}

extension JavaScript {
    enum Wechat: Scriptable {
        case auth

        var code: String {
            ""
        }

        var message: String {
            ""
        }

        var data: [String: String] {
            [:]
        }

        var method: Method {
            .auth
        }

        enum Method: String, MethodAble {
            case auth = ""

            var name: String {
                switch self {
                case .auth: return ""
                }
            }
        }
    }
}

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

        var code: String {
            switch self {
            case .networkFailed: return "DMD001"
            case .authorization(let info): return info.code
            }
        }

        var message: String {
            switch self {
            case .networkFailed: return "请安装sim卡或者开启流量"
            case .authorization(let info): return info.message
            }
        }

        var data: [String: String] {
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
        case authorization((code: String, token: String, operator: String, message: String))
    }
}