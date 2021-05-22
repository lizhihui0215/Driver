//
//  ScanAnimationImageView.swift
//  Assets
//
//  Created by lizhihui on 2021/5/2.
//  Copyright © 2021 ZhiHui.Li. All rights reserved.
//

import UIKit

class ScanAnimationImageView: UIImageView {
    var isInAnimating = false
    var animationFrame: CGRect = .zero

    func startAnimation() {
        isHidden = false
        isInAnimating = true
        stepAnimation()
    }

    @objc func stepAnimation() {
        guard isInAnimating else { return }
        var frame = self.frame

        let hImg = image!.size.height

        frame.origin.y -= hImg
        frame.size.height = hImg
        self.frame = frame

        alpha = 0.0

        UIView.animate(withDuration: 1.2, animations: {
            self.alpha = 1.0

            var frame = self.bounds
            let hImg = self.image!.size.height

            frame.origin.y += (frame.size.height - hImg)
            frame.size.height = hImg

            self.frame = frame

        }, completion: { _ in
            self.perform(#selector(Self.stepAnimation), with: nil, afterDelay: 0.3)
        })
    }

    func stopAnimation() {
        isHidden = true
        isInAnimating = false
    }
}
