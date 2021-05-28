//
//  PermissionManager.swift
//  Driver
//
//  Created by Bernard on 2021/5/28.
//

import Foundation
import AVFoundation
import Photos

class PermissionManager {
    public static let shared = PermissionManager()
    
    var isCameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    var isCameraAuthorization: Bool {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        return authorizationStatus == .authorized  || authorizationStatus == .notDetermined
    }

    var isLibraryAuthorization: Bool {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        return authorizationStatus == .authorized || authorizationStatus == .notDetermined
    }
    
    init() {
        
    }
}
