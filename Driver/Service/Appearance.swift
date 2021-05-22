//
// Created by lizhihui on 2021/5/1.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation
import UIKit

class Appearance {
    public static let shared = Appearance()

    enum TitleTextAttributes {
        var attributes: [NSAttributedString.Key: Any] {
            switch self {
            case .navigationBar: return [.foregroundColor: XCAssets.Colors.secondaryTextColor.color,
                                         .font: UIFont.boldSystemFont(ofSize: 20)]
            }
        }

        case navigationBar
    }

    enum TintColor {
        case barButtonItem
        case navigationBar

        var color: UIColor {
            switch self {
            case .barButtonItem: return .white
            case .navigationBar: return .white
            }
        }
    }

    func launch() {
        configureUIKitAppearance()
    }

    private func configureUIKitAppearance() {
        UIBarButtonItem.appearance().tintColor = TintColor.barButtonItem.color
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
        UINavigationBar.appearance().titleTextAttributes = TitleTextAttributes.navigationBar.attributes
        UINavigationBar.appearance().tintColor = TintColor.navigationBar.color
    }
}
