//
//  Bundle+Extension.swift
//  Siren
//
//  Created by ZhiHui.Li on 2021/4/18. on 3/17/17.
//  Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation

// `Bundle` Extension for Siren.
extension Bundle {
    /// Constants used in the `Bundle` extension.
    enum Constants {
        /// Constant for the `.bundle` file extension.
        static let bundleExtension = "bundle"
        /// Constant for `CFBundleDisplayName`.
        static let displayName = "CFBundleDisplayName"
        /// Constant for the default US English localization.
        static let englishLocalization = "en"
        /// Constant for the project file extension.
        static let projectExtension = "lproj"
        /// Constant for `CFBundleShortVersionString`.
        static let shortVersionString = "CFBundleShortVersionString"
        /// Constant for the localization table.
        static let table = "SirenLocalizable"
    }

    final class func identifier() -> String? {
        Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String
    }

    /// Fetches the current version of the app.
    ///
    /// - Returns: The current installed version of the app.
    final class func version() -> String? {
        Bundle.main.object(forInfoDictionaryKey: Constants.shortVersionString) as? String
    }

    final class func build() -> String? {
        Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    /// The appropriate name for the app to be displayed in the update alert.
    ///
    /// Siren checks `CFBundleDisplayName` first. It then falls back to
    /// to `kCFBundleNameKey` and ultimately to an empty string
    /// if the aforementioned values are nil.
    ///
    /// - Returns: The name of the app.
    final class func bestMatchingAppName() -> String {
        let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: Constants.displayName) as? String
        let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
        let executableName = Bundle.main.object(forInfoDictionaryKey: kCFBundleExecutableKey as String) as? String
        let processInfoName = ProcessInfo.processInfo.arguments.first?.split(separator: "/").last.map(String.init)
        return bundleDisplayName ?? bundleName ?? executableName ?? processInfoName ?? ""
    }
}
