//
//  Javascript.swift
//  Driver
//
//  Created by lizhihui on 2021/5/22.
//

import Foundation

protocol Scriptable {
    associatedtype Method: MethodAble
    var status: Int { get }
    var message: String { get }
    var data: [String: String?] { get }
    var body: JavaScript.Body { get }
    var method: Method { get }
    func script() -> String
}

extension Scriptable {
    func script() -> String {
        method.build(body: body)
    }

    var body: JavaScript.Body {
        JavaScript.Body(status: status, message: message, data: data)
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

struct JavaScript {}

extension JavaScript {
    struct Body: Encodable {
        let status: Int
        let message: String
        let data: [String: String?]

        func toJSONString() -> String {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            guard let data = try? encoder.encode(self) else { return "" }

            return String(data: data, encoding: .utf8) ?? ""
        }
    }
}
