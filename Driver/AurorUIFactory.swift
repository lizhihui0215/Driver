//
//  AurorUIFactory.swift
//  Driver
//
//  Created by lizhihui on 2021/5/24.
//

import Foundation
import UIKit

class AurorUIFactory {
    private static let `default` = AurorUIFactory()

    lazy var auroraNavTextAttributes: [NSAttributedString.Key: Any] = {
        [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 18)]
    }()

    let auroraUIConfiguration = JVUIConfig()

    lazy var auroraLogoConstraints: [JVLayoutConstraint] = {
        let logoWidth: CGFloat = 100
        let logoHeight = logoWidth
        let logoConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let logoConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: -90)
        let logoConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: logoWidth)
        let logoConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: logoHeight)

        return [logoConstraintX!, logoConstraintY!, logoConstraintW!, logoConstraintH!]
    }()

    lazy var auroraPhoneConstraints: [JVLayoutConstraint] = {
        let numberConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let numberConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: -55)
        let numberConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 130)
        let numberConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 25)
        return [numberConstraintX!, numberConstraintY!, numberConstraintW!, numberConstraintH!]
    }()

    lazy var auroraSloganConstraints: [JVLayoutConstraint] = {
        // slogan
        let sloganConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let sloganConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: -20)
        let sloganConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 130)
        let sloganConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 20)
        return [sloganConstraintX!, sloganConstraintY!, sloganConstraintW!, sloganConstraintH!]
    }()

    lazy var auroraLoginButtonImages: [UIImage] = {
        // 登录按钮
        [XCAssets.Assets.Aurora.loginBtnNor.image,
         XCAssets.Assets.Aurora.loginBtnDis.image,
         XCAssets.Assets.Aurora.loginBtnHig.image]
    }()

    lazy var auroraLoginButtonConstraints: [JVLayoutConstraint] = {
        let normalImage = auroraUIConfiguration.logBtnImgs.first as? UIImage
        let loginBtnWidth = normalImage?.size.width ?? 100
        let loginBtnHeight = normalImage?.size.height ?? 100
        let loginConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let loginConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 30)
        let loginConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: loginBtnWidth)
        let loginConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: loginBtnHeight)
        return [loginConstraintX!, loginConstraintY!, loginConstraintW!, loginConstraintH!]
    }()

    lazy var auroraCheckViewConstraints: [JVLayoutConstraint] = {
        let checkViewWidth: CGFloat = 50
        let checkViewConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 20)
        let checkViewConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.privacy, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let checkViewConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: checkViewWidth)
        let checkViewConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: checkViewWidth)
        return [checkViewConstraintX!, checkViewConstraintY!, checkViewConstraintW!, checkViewConstraintH!]
    }()

    lazy var auroraPrivacyViewConstraints: [JVLayoutConstraint] = {
        let checkViewWidth: CGFloat = 50
        // 隐私
        let spacing = checkViewWidth + 20 + 5
        let privacyConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: spacing)
        let privacyConstraintX2 = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: -spacing)
        let privacyConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -10)
        let privacyConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 50)
        return [privacyConstraintX!, privacyConstraintX2!, privacyConstraintY!, privacyConstraintH!]
    }()

    lazy var auroraLoadingViewConstraints: [JVLayoutConstraint] = {
        // loading
        let loadingConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let loadingConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let loadingConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 30)
        let loadingConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 30)
        return [loadingConstraintX!, loadingConstraintY!, loadingConstraintW!, loadingConstraintH!]
    }()

    static func makeUIConfiguration() -> JVUIConfig {
        AurorUIFactory.default.UIConfiguration()
    }

    func UIConfiguration() -> JVUIConfig {
        auroraUIConfiguration.navCustom = false
        auroraUIConfiguration.navText = NSAttributedString(string: "登录统一认证", attributes: auroraNavTextAttributes)
        auroraUIConfiguration.navReturnHidden = false
        auroraUIConfiguration.navReturnImg = XCAssets.Assets.Aurora.close.image
        auroraUIConfiguration.agreementNavReturnImage = XCAssets.Assets.Aurora.close.image
        auroraUIConfiguration.shouldAutorotate = true
        auroraUIConfiguration.autoLayout = true
        auroraUIConfiguration.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        auroraUIConfiguration.logoImg = XCAssets.Assets.Aurora.logo.image
        auroraUIConfiguration.logoConstraints = auroraLogoConstraints
        auroraUIConfiguration.logoHorizontalConstraints = auroraUIConfiguration.logoConstraints
        auroraUIConfiguration.numberConstraints = auroraPhoneConstraints
        auroraUIConfiguration.numberHorizontalConstraints = auroraUIConfiguration.numberConstraints
        auroraUIConfiguration.sloganConstraints = auroraSloganConstraints
        auroraUIConfiguration.sloganHorizontalConstraints = auroraUIConfiguration.sloganConstraints
        auroraUIConfiguration.logBtnImgs = auroraLoginButtonImages
        auroraUIConfiguration.logBtnConstraints = auroraLoginButtonConstraints
        auroraUIConfiguration.logBtnText = ""
        auroraUIConfiguration.logBtnHorizontalConstraints = auroraUIConfiguration.logBtnConstraints

        auroraUIConfiguration.uncheckedImg = XCAssets.Assets.Aurora.checkBoxUnSelected.image
        auroraUIConfiguration.checkedImg = XCAssets.Assets.Aurora.checkBoxSelected.image
        auroraUIConfiguration.checkViewConstraints = auroraCheckViewConstraints
        auroraUIConfiguration.checkViewHorizontalConstraints = auroraUIConfiguration.checkViewConstraints

        auroraUIConfiguration.privacyState = true
        auroraUIConfiguration.privacyTextFontSize = 12
        auroraUIConfiguration.privacyTextAlignment = NSTextAlignment.center
        auroraUIConfiguration.privacyConstraints = auroraPrivacyViewConstraints
        auroraUIConfiguration.privacyHorizontalConstraints = auroraUIConfiguration.privacyConstraints

        auroraUIConfiguration.loadingConstraints = auroraLoadingViewConstraints
        auroraUIConfiguration.loadingHorizontalConstraints = auroraUIConfiguration.loadingConstraints
        return auroraUIConfiguration
    }
}
