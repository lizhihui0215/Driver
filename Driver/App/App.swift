//
//  App.swift
//  Assets
//
//  Created by ZhiHui.Li on 2021/4/14.
//  Copyright © 2021 ZhiHui.Li. All rights reserved.
//

import Foundation

let app = App()

public final class App {
    enum Constants {
        enum Default {
            static let text = ""
            static let string = ""
        }

        static let unknown = "Unknown"
        static let defaultLanguage = "en"
        static let osName = "iOS"
        static let brand = "Apple"
    }

    enum Keys: String {
        case Credential

        enum AppInfo: String {
            case Version = "appVersionCode"
            case Build = "appVersionName"
            case Brand = "deviceBrand"
            case Language = "systemLanguage"
            case Model = "systemModel"
            case OsVersion = "systemVersion"
        }
    }

    private var infoDictionary = Bundle.main.infoDictionary

    public enum Category: String, Codable {
        case ios = "2"
    }

    lazy var info: [String: String] = {
        [Keys.AppInfo.Version.rawValue: self.version,
         Keys.AppInfo.Build.rawValue: self.build,
         Keys.AppInfo.Brand.rawValue: self.brand,
         Keys.AppInfo.Language.rawValue: self.systemLanguage,
         Keys.AppInfo.Model.rawValue: self.build,
         Keys.AppInfo.OsVersion.rawValue: self.osVersion]
    }()

    public var version: String {
        Bundle.version() ?? Constants.unknown
    }

    public var build: String {
        Bundle.build() ?? Constants.unknown
    }

    public var identifier: String {
        Bundle.identifier() ?? Constants.unknown
    }

    public var brand: String {
        Constants.brand
    }

    public var model: String {
        Device.current.description
    }

    public var osName: String {
        Constants.osName
    }

    public var executableName: String {
        let name = Bundle.bestMatchingAppName()
        guard name.isEmpty else { return Constants.unknown }
        return name
    }

    public var appLanguage: String {
        Locale.preferredLanguages[0]
    }

    public var systemLanguage: String {
        Locale.current.languageCode ?? Constants.defaultLanguage
    }

    public var osVersion: String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }
}
