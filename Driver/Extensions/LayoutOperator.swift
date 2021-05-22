//
//  LayoutOperator.swift
//  Assets
//
//  Created by ZhiHui.Li on 2021/4/16.
//  Copyright © 2021 ZhiHui.Li. All rights reserved.
//

import Foundation
import Swiftstraints
import UIKit

precedencegroup LayoutAnchorPrecedence {
    associativity: right
    lowerThan: AdditionPrecedence
    higherThan: AssignmentPrecedence
}

infix operator ~: LayoutAnchorPrecedence
infix operator <~: LayoutAnchorPrecedence
infix operator >~: LayoutAnchorPrecedence

@discardableResult public func ~ <T: AxisAnchor, U: AxisAnchor>(lhs: T, rhs: U) -> NSLayoutConstraint where T.AnchorType == U.AnchorType {
    (lhs == rhs).activate()
}

@discardableResult public func <~ <T: AxisAnchor, U: AxisAnchor>(lhs: T, rhs: U) -> NSLayoutConstraint where T.AnchorType == U.AnchorType {
    (lhs <= rhs).activate()
}

@discardableResult public func >~ <T: AxisAnchor, U: AxisAnchor>(lhs: T, rhs: U) -> NSLayoutConstraint where T.AnchorType == U.AnchorType {
    (lhs >= rhs).activate()
}

// Dimension to dimension

@discardableResult public func ~ (lhs: DimensionAnchor, rhs: DimensionAnchor) -> NSLayoutConstraint {
    (lhs == rhs).activate()
}

@discardableResult public func >~ (dimension: DimensionAnchor, rhs: DimensionAnchor) -> NSLayoutConstraint {
    (dimension >= rhs).activate()
}

@discardableResult public func <~ (dimension: DimensionAnchor, rhs: DimensionAnchor) -> NSLayoutConstraint {
    (dimension <= rhs).activate()
}

// Dimension to constant

@discardableResult public func >~ (dimension: DimensionAnchor, constant: CGFloat) -> NSLayoutConstraint {
    (dimension >= constant).activate()
}

@discardableResult public func <~ (dimension: DimensionAnchor, constant: CGFloat) -> NSLayoutConstraint {
    (dimension <= constant).activate()
}

@discardableResult public func ~ (dimension: DimensionAnchor, constant: CGFloat) -> NSLayoutConstraint {
    (dimension == constant).activate()
}

// priorities

@discardableResult public func >~ (dimension: DimensionAnchor, constant: PrioritizedConstant) -> NSLayoutConstraint {
    (dimension >= constant).activate()
}

@discardableResult public func <~ (dimension: DimensionAnchor, constant: PrioritizedConstant) -> NSLayoutConstraint {
    (dimension <= constant).activate()
}

@discardableResult public func ~ (dimension: DimensionAnchor, constant: PrioritizedConstant) -> NSLayoutConstraint {
    (dimension == constant).activate()
}
