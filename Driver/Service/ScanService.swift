//
// Created by lizhihui on 2021/5/1.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import AVFoundation
import Foundation

public struct MetadataObject {
    var messageString: String?

    var type: AVMetadataObject.ObjectType

    var bounds: CGRect

    public var metadataObject: AVMetadataMachineReadableCodeObject?

    public init(metadataObject: AVMetadataMachineReadableCodeObject) {
        self.metadataObject = metadataObject
        messageString = metadataObject.stringValue
        type = metadataObject.type
        bounds = metadataObject.bounds
    }

    public init(messageString: String?, type: AVMetadataObject.ObjectType, bounds: CGRect) {
        self.messageString = messageString
        self.type = type
        self.bounds = bounds
    }
}

class ScanService: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    typealias ShouldContinueScanHandler = (Bool) -> Void
    typealias DidReceivedMetadataObject = (_ metadataObject: MetadataObject, _ completionHandler: @escaping ShouldContinueScanHandler) -> Void

    public static let shared = ScanService()!
    public var didReceivedMetadataObject: DidReceivedMetadataObject?
    public var previewLayer: AVCaptureVideoPreviewLayer

    private let device: AVCaptureDevice
    private var input: AVCaptureDeviceInput
    private var output = AVCaptureMetadataOutput()
    private let session = AVCaptureSession()
    private var stillImageOutput: AVCapturePhotoOutput
    private let outputQueue: DispatchQueue
    private var shouldProcessingToNext = true

    public var isTorchAvailable: Bool {
        device.isTorchAvailable
    }

    public var torchMode: AVCaptureDevice.TorchMode {
        get {
            device.torchMode
        }
        set {
            try? device.lockForConfiguration()
            device.torchMode = newValue
            device.unlockForConfiguration()
        }
    }

    public init?(support scanTypes: [AVMetadataObject.ObjectType] = [.qr, .code128],
                 rectOfInterest: CGRect = .zero,
                 outputQueue: DispatchQueue = .main)
    {
        stillImageOutput = AVCapturePhotoOutput()
        self.outputQueue = outputQueue
        guard let device = AVCaptureDevice.default(for: .video) else { return nil }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return nil }
        self.device = device
        self.input = input
        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(output) { session.addOutput(output) }
        if session.canAddOutput(stillImageOutput) { session.addOutput(stillImageOutput) }
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        super.init()
        output.metadataObjectTypes = scanTypes
        output.setMetadataObjectsDelegate(self, queue: outputQueue)
        session.sessionPreset = .high
        if !rectOfInterest.equalTo(.zero) { output.rectOfInterest = rectOfInterest }

        if device.isFocusPointOfInterestSupported, device.isFocusModeSupported(.continuousAutoFocus) {
            do {
                try input.device.lockForConfiguration()
                input.device.focusMode = .continuousAutoFocus
                input.device.unlockForConfiguration()
            } catch {
                log.debug("device lockForConfiguration error: \(error)")
            }
        }
    }

    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection)
    {
        guard shouldProcessingToNext else { return }

        for metadataObject in metadataObjects {
            guard let code = metadataObject as? AVMetadataMachineReadableCodeObject else {
                continue
            }

            let object = MetadataObject(metadataObject: code)
            log.debug("scanning received object output: \(output) metadataObjects: \(metadataObjects) connection: \(connection) ")

            guard let didReceivedMetadataObject = didReceivedMetadataObject else { return }
            `self`.shouldProcessingToNext = false
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                didReceivedMetadataObject(object) { `self`.shouldProcessingToNext = $0 }
            }
        }
    }

    func startRunning() {
        shouldProcessingToNext = true
        guard !session.isRunning else { return }
        session.startRunning()
    }

    func stopRunning(shouldProcessingToNext: Bool? = nil) {
        guard let shouldProcessingToNext = shouldProcessingToNext else {
            guard session.isRunning else { return }
            session.stopRunning()
            return
        }

        self.shouldProcessingToNext = shouldProcessingToNext
    }

    var defaultMetadataObjectTypes: [AVMetadataObject.ObjectType] {
        [.upce,
         .code39,
         .code39Mod43,
         .ean13,
         .ean8,
         .code93,
         .code128,
         .pdf417,
         .aztec,
         .interleaved2of5,
         .itf14,
         .dataMatrix]
    }

    public func discernMetadataObject(from image: UIImage) -> MetadataObject? {
        guard let image = image.ciImage else { return nil }

        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                        context: nil,
                                        options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        else {
            return nil
        }

        let features = detector.features(in: image, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

        guard let codeFeature = (features.compactMap { $0 as? CIQRCodeFeature }.first) else { return nil }

        return MetadataObject(messageString: codeFeature.messageString, type: .qr, bounds: codeFeature.bounds)
    }

    // MARK: - --- backup codes

//    public static func createCode(codeType: String, codeString: String, size: CGSize, qrColor: UIColor, bkColor: UIColor) -> UIImage? {
//        let stringData = codeString.data(using: .utf8)
//
//        // 系统自带能生成的码
//        //        CIAztecCodeGenerator
//        //        CICode128BarcodeGenerator
//        //        CIPDF417BarcodeGenerator
//        //        CIQRCodeGenerator
//        let qrFilter = CIFilter(name: codeType)
//        qrFilter?.setValue(stringData, forKey: "inputMessage")
//        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
//
//        // 上色
//        let colorFilter = CIFilter(name: "CIFalseColor",
//                                   parameters: [
//                                       "inputImage": qrFilter!.outputImage!,
//                                       "inputColor0": CIColor(cgColor: qrColor.cgColor),
//                                       "inputColor1": CIColor(cgColor: bkColor.cgColor),
//                                   ])
//
//        guard let qrImage = colorFilter?.outputImage,
//              let cgImage = CIContext().createCGImage(qrImage, from: qrImage.extent)
//        else {
//            return nil
//        }
//
//        UIGraphicsBeginImageContext(size)
//        let context = UIGraphicsGetCurrentContext()!
//        context.interpolationQuality = CGInterpolationQuality.none
//        context.scaleBy(x: 1.0, y: -1.0)
//        context.draw(cgImage, in: context.boundingBoxOfClipPath)
//        let codeImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return codeImage
//    }

//    open func captureImage() {
//        guard let stillImageConnection = connectionWithMediaType(mediaType: AVMediaType.video as AVMediaType,
//                connections: stillImageOutput.connections as [AnyObject]) else {
//            return
//        }
//        stillImageOutput.captureStillImageAsynchronously(from: stillImageConnection, completionHandler: { (imageDataSampleBuffer, _) -> Void in
//            self.stop()
//            if let imageDataSampleBuffer = imageDataSampleBuffer,
//               let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer) {
//
//                let scanImg = UIImage(data: imageData)
//                for idx in 0 ... self.results.count - 1 {
//                    self.results[idx].imgScanned = scanImg
//                }
//            }
//            self.successBlock(self.results)
//        })
//    }

//    public static func createCode128(codeString: String, size: CGSize, qrColor: UIColor, bkColor: UIColor) -> UIImage? {
//        let stringData = codeString.data(using: String.Encoding.utf8)
//
//        // 系统自带能生成的码
//        //        CIAztecCodeGenerator 二维码
//        //        CICode128BarcodeGenerator 条形码
//        //        CIPDF417BarcodeGenerator
//        //        CIQRCodeGenerator     二维码
//        let qrFilter = CIFilter(name: "CICode128BarcodeGenerator")
//        qrFilter?.setDefaults()
//        qrFilter?.setValue(stringData, forKey: "inputMessage")
//
//        guard let outputImage = qrFilter?.outputImage else {
//            return nil
//        }
//        let context = CIContext()
//        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
//            return nil
//        }
//        let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: UIImage.Orientation.up)
//
//        // Resize without interpolating
//        return resizeImage(image: image, quality: CGInterpolationQuality.none, rate: 20.0)
//    }

//    open func connectionWithMediaType(mediaType: AVMediaType, connections: [AnyObject]) -> AVCaptureConnection? {
//        log.debug("scanning received object mediaType: \(mediaType) connections: \(connections)")
//        for connection in connections {
//            guard let connectionTmp = connection as? AVCaptureConnection else {
//                continue
//            }
//            for port in connectionTmp.inputPorts where port.mediaType == mediaType {
//                return connectionTmp
//            }
//        }
//        return nil
//    }
}
