// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum XCAssets {
  internal enum Assets {
    internal enum Aurora {
      internal static let checkBoxSelected = ImageAsset(name: "checkBox_selected")
      internal static let checkBoxUnSelected = ImageAsset(name: "checkBox_unSelected")
      internal static let close = ImageAsset(name: "close")
      internal static let cmccLogo = ImageAsset(name: "cmccLogo")
      internal static let ctccLogo = ImageAsset(name: "ctccLogo")
      internal static let cuccLogo = ImageAsset(name: "cuccLogo")
      internal static let loginBtnDis = ImageAsset(name: "loginBtn_Dis")
      internal static let loginBtnHig = ImageAsset(name: "loginBtn_Hig")
      internal static let loginBtnNor = ImageAsset(name: "loginBtn_Nor")
      internal static let logo = ImageAsset(name: "logo")
      internal static let windowClose = ImageAsset(name: "windowClose")
    }
    internal enum Hud {
      internal static let netError = ImageAsset(name: "net_error")
    }
    internal enum Scan {
      internal static let qrcodeScanBtnFlashDown = ImageAsset(name: "qrcode_scan_btn_flash_down")
      internal static let qrcodeScanBtnFlashNor = ImageAsset(name: "qrcode_scan_btn_flash_nor")
      internal static let qrcodeScanBtnPhotoDown = ImageAsset(name: "qrcode_scan_btn_photo_down")
      internal static let qrcodeScanBtnPhotoNor = ImageAsset(name: "qrcode_scan_btn_photo_nor")
      internal static let qrcodeScanFullNet = ImageAsset(name: "qrcode_scan_full_net")
    }
    internal enum Image {
      internal static let iconBack = ImageAsset(name: "icon_back")
      internal static let iconPhoneNumber = ImageAsset(name: "icon_phone_number")
      internal static let iconVerificationCode = ImageAsset(name: "icon_verification_code")
      internal static let navBack = ImageAsset(name: "nav_back")
      internal static let tabGerenzhongxinDis = ImageAsset(name: "tab_gerenzhongxin_dis")
      internal static let tabHuoyuanDis = ImageAsset(name: "tab_huoyuan_dis")
      internal static let tabLayunjiluDis = ImageAsset(name: "tab_layunjilu_dis")
      internal static let tabShouyeDis = ImageAsset(name: "tab_shouye_dis")
      internal static let tabZengzhifuwuDis = ImageAsset(name: "tab_zengzhifuwu_dis")
    }
  }
  internal enum Colors {
    internal enum DropDown {
      internal static let dropdownTextColor = ColorAsset(name: "dropdownTextColor")
    }
    internal enum Hud {
      internal static let background = ColorAsset(name: "background")
      internal static let errorButton = ColorAsset(name: "errorButton")
      internal static let errorTtitle = ColorAsset(name: "errorTtitle")
    }
    internal enum Scan {
      internal static let corner = ColorAsset(name: "corner")
      internal static let cornerfill = ColorAsset(name: "cornerfill")
    }
    internal enum TextField {
      internal static let borderActiveColor = ColorAsset(name: "borderActiveColor")
      internal static let borderInactiveColor = ColorAsset(name: "borderInactiveColor")
      internal static let placeholderColor = ColorAsset(name: "placeholderColor")
    }
    internal static let primaryColor = ColorAsset(name: "primaryColor")
    internal static let primaryTextColor = ColorAsset(name: "primaryTextColor")
    internal static let secondaryTextColor = ColorAsset(name: "secondaryTextColor")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
