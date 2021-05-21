//
//  CacheManager.swift
//  Assets
//
//  Created by ZhiHui.Li on 2021/4/14.
//  Copyright © 2021 ZhiHui.Li. All rights reserved.
//

import Foundation

struct Cache {}

@propertyWrapper
struct UserDefault<T: Codable, K: Keys> {
    let key: K
    let defaultValue: T

    init(key: K, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let obj = value() else {
                return defaultValue
            }
            return obj
        }
        set {
            add(data: newValue)
        }
    }

    func add(data: T) {
        let data = try? JSONEncoder().encode(data)
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }

    func value() -> T? {
        guard let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func synchronized() {
        add(data: defaultValue)
    }
}
