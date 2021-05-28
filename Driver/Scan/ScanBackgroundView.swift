//
//  ScanBackgroundView.swift
//  Driver
//
//  Created by lizhihui on 2021/5/22.
//

import Foundation

import UIKit

class ScanBackgroundView: UIView {
    var shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        clean()
        background()
    }

    func clean() {
        shapeLayer.removeFromSuperlayer()
    }

    func background() {
        guard let cornerView: ScanCornerView = firstSubView() else { return }
        let frame = cornerView.frame
        let edgeInsets = UIEdgeInsets(top: frame.minY, left: frame.minX, bottom: self.frame.maxY - frame.maxY, right: self.frame.maxX - frame.maxX)
        shapeLayer = CAShapeLayer()
        let bezierPath = UIBezierPath()
        let outer = UIBezierPath(rect: bounds)
        let inner = UIBezierPath(rect: bounds.inset(by: edgeInsets))

        bezierPath.append(outer)
        bezierPath.append(inner)
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillRule = .evenOdd
        shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.opacity = 0.5
        layer.addSublayer(shapeLayer)
    }
}
