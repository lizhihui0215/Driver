//
// Created by lizhihui on 2021/5/2.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import Foundation
import UIKit

class ScanCornerView: UIView {
    var cornerColor = UIColor(red: 0.0, green: 167.0 / 255.0, blue: 231.0 / 255.0, alpha: 1.0).cgColor
    var cornerfillColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    var lineWidth: CGFloat = 6.0
    var cornerWidth: CGFloat = 24.0
    var cornerHeight: CGFloat = 24.0

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setStrokeColor(cornerColor)
        context.setFillColor(cornerfillColor)
        context.setLineWidth(lineWidth)

        // left top horizontally line
        context.move(to: CGPoint(x: rect.minX - lineWidth / 2, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.minX + cornerWidth, y: rect.minY))

        // left top vertically line
        context.move(to: CGPoint(x: rect.minX, y: rect.minY - lineWidth / 2))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerHeight))

        // let bottom horizontally line
        context.move(to: CGPoint(x: rect.minX - lineWidth / 2, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.minX + cornerWidth, y: rect.maxY))

        // left bottm vertically line
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY + lineWidth / 2))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerHeight))

        // right top horizontally line
        context.move(to: CGPoint(x: rect.maxX + lineWidth / 2, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX - cornerWidth, y: rect.minY))

        // ringt top vertically line
        context.move(to: CGPoint(x: rect.maxX, y: rect.minY - lineWidth / 2))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerHeight))

        // right bottom horizontally line
        context.move(to: CGPoint(x: rect.maxX + lineWidth / 2, y: rect.maxX))
        context.addLine(to: CGPoint(x: rect.maxX - cornerWidth, y: rect.maxY))

        // right bottom vertically line
        context.move(to: CGPoint(x: rect.maxX, y: rect.maxY + lineWidth / 2))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerHeight))

        context.strokePath()
    }
}
