//
//  LayoutHelpers.swift
//  Assets
//
//  Created by ZhiHui.Li on 2021/4/16.
//  Copyright © 2021 ZhiHui.Li. All rights reserved.
//

import Foundation
import Swiftstraints
import UIKit

public protocol Anchorable {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

public extension Anchorable {
    /// Automatically activates constraints.
    @discardableResult func centerInView(_ anchorable: Anchorable) -> CenterLayoutGroup {
        CenterLayoutGroup(
            horizontal: centerXAnchor ~ anchorable.centerXAnchor,
            vertical: centerYAnchor ~ anchorable.centerYAnchor
        )
    }

    /// Automatically activates constraints.
    @discardableResult func fillView(_ anchorable: Anchorable, insets: UIEdgeInsets = UIEdgeInsets()) -> EdgeLayoutGroup {
        EdgeLayoutGroup(
            leading: leadingAnchor ~ anchorable.leadingAnchor + insets.right,
            trailing: trailingAnchor ~ anchorable.trailingAnchor - insets.left,
            top: topAnchor ~ anchorable.topAnchor + insets.top,
            bottom: bottomAnchor ~ anchorable.bottomAnchor - insets.bottom
        )
    }

    /// Automatically activates constraints.
    @discardableResult func fillViewHorizontally(_ anchorable: Anchorable, padding: CGFloat = 0) -> AxisLayoutGroup {
        AxisLayoutGroup(
            leading: leadingAnchor ~ anchorable.leadingAnchor + padding,
            trailing: trailingAnchor ~ anchorable.trailingAnchor - padding
        )
    }

    /// automatically activates constraints
    @discardableResult func fillViewVertically(_ anchorable: Anchorable, padding: CGFloat = 0) -> AxisLayoutGroup {
        AxisLayoutGroup(
            leading: topAnchor ~ anchorable.topAnchor + padding,
            trailing: bottomAnchor ~ anchorable.bottomAnchor - padding
        )
    }
}

extension UILayoutGuide: Anchorable {}

extension UIView: Anchorable {
    /// Automatically activates constraints, and sets translatesAutoresizingMaskIntoConstraints to false. Must have superview.
    @discardableResult public func fillSuperview(_ insets: UIEdgeInsets = UIEdgeInsets()) -> EdgeLayoutGroup {
        translatesAutoresizingMaskIntoConstraints = false
        assert(superview != nil)
        return fillView(superview!, insets: insets)
    }

    /// Automatically activates constraints, and sets translatesAutoresizingMaskIntoConstraints to false. Must have superview.
    @discardableResult public func fillSuperviewHorizontally(_ padding: CGFloat = 0) -> AxisLayoutGroup {
        translatesAutoresizingMaskIntoConstraints = false
        assert(superview != nil)
        return fillViewHorizontally(superview!, padding: padding)
    }

    /// Automatically activates constraints, and sets translatesAutoresizingMaskIntoConstraints to false. Must have superview.
    @discardableResult public func fillSuperviewVertically(_ padding: CGFloat = 0) -> AxisLayoutGroup {
        translatesAutoresizingMaskIntoConstraints = false
        assert(superview != nil)
        return fillViewVertically(superview!, padding: padding)
    }

    /// Automatically activates constraints, and sets translatesAutoresizingMaskIntoConstraints to false. Must have superview.
    @discardableResult public func centerInSuperView() -> CenterLayoutGroup {
        centerInView(superview!)
    }
}

public extension NSLayoutConstraint {
    @discardableResult func activate() -> Self {
        isActive = true
        if let view = firstItem as? UIView {
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        return self
    }

    @discardableResult func activate(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return activate()
    }
}

public struct EdgeLayoutGroup {
    public var leading: NSLayoutConstraint
    public var trailing: NSLayoutConstraint
    public var top: NSLayoutConstraint
    public var bottom: NSLayoutConstraint

    public var horizontal: [NSLayoutConstraint] {
        [leading, trailing]
    }

    public var vertical: [NSLayoutConstraint] {
        [top, bottom]
    }

    public var all: [NSLayoutConstraint] {
        [leading, trailing, top, bottom]
    }
}

public struct CenterLayoutGroup {
    public var horizontal: NSLayoutConstraint
    public var vertical: NSLayoutConstraint

    public var all: [NSLayoutConstraint] {
        [horizontal, vertical]
    }
}

public struct AxisLayoutGroup {
    public var leading: NSLayoutConstraint
    public var trailing: NSLayoutConstraint

    public var all: [NSLayoutConstraint] {
        [leading, trailing]
    }
}
