//
//  Map.swift
//  Driver
//
//  Created by lizhihui on 2021/5/24.
//

import Foundation

extension JavaScript {
    enum Map: Scriptable {
        case baidu
        case amap

        var status: Int { 0 }

        var message: String { "" }

        var data: [String: String?] {
            switch self {
            default: return [:]
            }
        }

        var method: Method {
            switch self {
            case .baidu: return .baidu
            case .amap: return .amap
            }
        }

        enum Method: String, MethodAble {
            case baidu
            case amap

            var name: String {
                switch self {
                case .baidu: return "baiduMap"
                case .amap: return "aMap"
                }
            }
        }
    }
}
