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
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        return authorizationStatus == .authorized
    }

    init() {}
}
