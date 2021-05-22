//
// Created by ZhiHui.Li on 2021/4/18.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation

protocol Keys {
    var rawValue: String { get }
    var key: String { get }
}

extension Keys {
    var key: String {
        rawValue
    }
}

extension App.Keys: Keys {}

extension App.Keys.AppInfo: Keys {}
