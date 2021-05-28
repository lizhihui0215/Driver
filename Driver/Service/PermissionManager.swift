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

    func requestAccess(for mediaType: AVMediaType,
                       completionHandler handler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { status in
            handler(status)
        }
    }
}
