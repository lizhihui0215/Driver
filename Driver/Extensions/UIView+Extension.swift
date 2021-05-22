//
//  UIView+Extension.swift
//  Driver
//
//  Created by lizhihui on 2021/5/22.
//

import Foundation
import UIKit

public extension UIView {
    func firstSubView<T: UIView>() -> T? {
        var views: [UIView] = subviews
        while views.count > 0 {
            let view = views[0]
            if let currentView = view as? T {
                return currentView
            }
            views.append(contentsOf: view.subviews)
            views.remove(at: 0)
        }
        return nil
    }

    func subviews<T: UIView>(_ viewType: T.Type) -> [T] {
        var filteredViews: [T] = []
        var views: [UIView] = subviews
        while views.count > 0 {
            let view = views[0]
            if let currentView = view as? T {
                filteredViews.append(currentView)
            }
            views.append(contentsOf: view.subviews)
            views.remove(at: 0)
        }
        return filteredViews
    }
}
