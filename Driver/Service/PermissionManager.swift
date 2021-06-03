//
//  PermissionManager.swift
//  Driver
//
//  Created by Bernard on 2021/5/28.
//

import AVFoundation
import Foundation
import Photos

class PermissionManager {
    enum Permission {
        case avCapture(AVMediaType)
        case photoLibrary
    }

    public static let shared = PermissionManager()

    var isCameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    var isCameraAuthorization: Bool {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        return authorizationStatus == .authorized
    }

    var isLibraryAuthorization: Bool {
        let authorizationStatus: PHAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            authorizationStatus = PHPhotoLibrary.authorizationStatus()
        }
        return authorizationStatus == .authorized
    }

    init() {}

    func requestAccess(for permission: Permission,
                       completionHandler handler: ((Bool) -> Void)? = nil)
    {
        switch permission {
        case .avCapture:
            AVCaptureDevice.requestAccess(for: .video) { status in
                guard let handler = handler else { return }
                handler(status)
            }
        case .photoLibrary:
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) {
                    guard let handler = handler else { return }
                    handler($0 == .authorized)
                }
            } else {
                PHPhotoLibrary.requestAuthorization {
                    guard let handler = handler else { return }
                    handler($0 == .authorized)
                }
            }
        }
    }
}
