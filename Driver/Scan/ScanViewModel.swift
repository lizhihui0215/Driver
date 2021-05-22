//
// Created by lizhihui on 2021/5/2.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import AVFoundation
import BrightFutures
import Foundation
import UIKit

typealias ViewModelFuture<Success> = Future<Success, Error>

class ScanViewModel {
    enum Constants {
        static let scanAudioFileName = "scan"
        static let scanAudioFileExtension = "wav"
    }

    var metadataObject: MetadataObject!
    var didReceivedMetadataObject: ScanService.DidReceivedMetadataObject?
    typealias SegueIdentifier = String

    let scanner = ScanService.shared

    public var previewLayer: AVCaptureVideoPreviewLayer {
        scanner.previewLayer
    }

    var isTorchAvailable: Bool {
        scanner.isTorchAvailable
    }

    public var torchMode: AVCaptureDevice.TorchMode {
        get {
            scanner.torchMode
        }
        set {
            scanner.torchMode = newValue
        }
    }

    final func startScanning() -> ViewModelFuture<MetadataObject> {
        ViewModelFuture<MetadataObject> { completion in
            scanner.didReceivedMetadataObject = { [weak self] metadataObject, completionHandler in
                guard let self = self else { return }
                `self`.metadataObject = metadataObject
                completionHandler(false)
                completion(.success(metadataObject))
                `self`.playBee()
            }
            scanner.startRunning()
        }
    }

    func playBee() {
        var soundId: SystemSoundID = 1
        let audioPath = Bundle.main.url(forResource: Constants.scanAudioFileName, withExtension: Constants.scanAudioFileExtension)
        let error = AudioServicesCreateSystemSoundID(audioPath! as CFURL, &soundId)
        log.debug("audio error \(error)")
        AudioServicesPlaySystemSound(soundId)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) // 静音模式下震动
    }

    func discernMetadataObject(from image: UIImage) -> Bool {
        guard let metadataObject = scanner.discernMetadataObject(from: image) else { return false }
        self.metadataObject = metadataObject
        playBee()
        return true
    }

    func finished() -> ViewModelFuture<SegueIdentifier> {
        fatalError("sub class must implement this method to handler finished")
    }

    func stopScanning() {
        scanner.stopRunning()
    }
}
