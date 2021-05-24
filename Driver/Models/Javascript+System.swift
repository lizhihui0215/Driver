//
//  System.swift
//  Driver
//
//  Created by lizhihui on 2021/5/24.
//

import Foundation

extension JavaScript {
    enum System: Scriptable {
        case scan(code: String? = nil)
        case tel
        case pasteBoardResponse(paste: String)
        case pasteBoard

        var status: Int { 0 }

        var message: String { "" }

        var data: [String: String?] {
            switch self {
            case .scan(let code): return ["code": code]
            case .pasteBoardResponse(let paste): return ["paste": paste]
            default: return [:]
            }
        }

        var method: Method {
            switch self {
            case .scan: return .scan
            case .tel: return .tel
            case .pasteBoardResponse: return .pasteBoardResponse
            case .pasteBoard: return .pasteBoard
            }
        }

        enum Method: String, MethodAble {
            case scan = "scanRsp"
            case tel
            case pasteBoardResponse
            case pasteBoard

            var name: String {
                switch self {
                case .scan: return "jsOpenScan"
                case .tel: return "jsOpenTel"
                case .pasteBoardResponse: return "pasteBoardResponse"
                case .pasteBoard: return "pasteBoard"
                }
            }
        }
    }
}
