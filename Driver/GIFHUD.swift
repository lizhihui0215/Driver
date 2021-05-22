//
//  GIFHDU.swift
//  Driver
//
//  Created by lizhihui on 2021/5/21.
//

import Gifu
import Swiftstraints
import UIKit

class GIFHUD: UIViewController {
    enum HUDType {
        case loading
        case error
    }

    class BackgroundView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = XCAssets.Colors.Hud.background.color
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    class ErrorView: UIView {
        lazy var errorImageView: UIImageView = {
            let imageView = UIImageView(image: XCAssets.Assets.Hud.netError.image)
            return imageView
        }()

        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "网络异常，请确认当前设备网络。"
            label.textColor = XCAssets.Colors.Hud.errorTtitle.color
            return label
        }()

        lazy var button: UIButton = {
            let button = UIButton(type: .custom)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 5
            button.backgroundColor = XCAssets.Colors.Hud.errorButton.color
            button.heightAnchor ~ 40
            button.widthAnchor ~ 100
            button.titleLabel?.textColor = .white
            button.setTitle("重新加载", for: .normal)
            return button
        }()

        var action: ((UIButton) -> Void)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(errorImageView)
            errorImageView.addSubview(titleLabel)
            errorImageView.addSubview(button)
            errorImageView.centerXAnchor ~ centerXAnchor
            errorImageView.centerYAnchor ~ centerYAnchor
            titleLabel.centerXAnchor ~ errorImageView.centerXAnchor
            titleLabel.topAnchor ~ errorImageView.topAnchor + 20
            button.centerXAnchor ~ errorImageView.centerXAnchor
            button.topAnchor ~ titleLabel.topAnchor + 20
            button.addTarget(self, action: #selector(Self.buttonTapped(_:)), for: .touchUpInside)
        }

        @objc func buttonTapped(_ sender: UIButton) {
            guard let action = action else { return }
            action(sender)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    public static let shared = GIFHUD()

    public var background = BackgroundView()

    var window: UIWindow! {
        UIApplication.shared.appDelegate.windowService?.window!
    }

    lazy var errorView: ErrorView = {
        let errorView = ErrorView()
        return errorView
    }()

    lazy var imageView: GIFImageView = {
        let imageView = GIFImageView()
        imageView.animate(withGIFNamed: "car_loading")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(background)
        background.fillSuperview()
    }

    func show(_ type: HUDType = .loading) {
        hideAll()
        window.rootViewController?.view.addSubview(view)
        view.fillSuperview()
        switch type {
        case .error:
            showError()
        case .loading:
            showLoading()
        }
    }

    func hideAll() {
        hideError()
        hideLoading()
    }

    func showError() {
        view.addSubview(errorView)
        errorView.fillSuperview()
    }

    func hideError() {
        errorView.removeFromSuperview()
    }

    func showLoading() {
        view.addSubview(imageView)
        imageView.widthAnchor ~ 250
        imageView.heightAnchor ~ 176
        imageView.centerYAnchor ~ view.centerYAnchor
        imageView.centerXAnchor ~ view.centerXAnchor
        imageView.startAnimatingGIF()
    }

    func hideLoading() {
        imageView.removeFromSuperview()
        imageView.stopAnimatingGIF()
    }

    func hide() {
        hideAll()
        view.removeFromSuperview()
    }
}
