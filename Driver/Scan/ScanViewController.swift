//
// Created by lizhihui on 2021/5/1.
// Copyright (c) 2021 ZhiHui.Li. All rights reserved.
//

import BrightFutures
import Foundation
import ZLPhotoBrowser

class ScanViewController: BaseViewController {
    @IBOutlet var scanAnimationImageView: ScanAnimationImageView!
    @IBOutlet var torchButton: UIButton!
//    @IBOutlet var finishedButton: UIButton!

    @IBOutlet var buttonStackView: UIStackView!
    var viewModel: ScanViewModel!

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScanning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        guard PermissionManager.shared.isCameraAuthorization else {
            alert(message: "请打开您的相机权限,以便于您能正常使用扫一扫扫描识别条码或者二维码,或者拍摄照片上传照片等功能")
            return
        }

        guard PermissionManager.shared.isLibraryAuthorization else {
            alert(message: "请打开您的相册权限,以便于您能正常使用扫一扫扫描识别条码或者二维码,或者拍摄照片上传照片等功能")
            return
        }

        startScanning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.insertSublayer(viewModel.previewLayer, at: 0)
        viewModel.previewLayer.frame = UIScreen.main.bounds
        startScanning()
        if !viewModel.isTorchAvailable {
            buttonStackView.removeArrangedSubview(torchButton)
            torchButton.removeFromSuperview()
        }
    }

    private func stopScanning() {
        viewModel.stopScanning()
        scanAnimationImageView.stopAnimation()
    }

    private func startScanning() {
//        `self`.finishedButton.isEnabled = false
        scanAnimationImageView.startAnimation()
        viewModel.startScanning().onSuccess { [weak self] _ in
            guard let self = self else { return }
            `self`.scanAnimationImageView.stopAnimation()
            `self`.perform(segue: StoryboardSegue.Main.scanFinished, sender: self)
        }
    }

    @IBAction func flashTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.torchMode = sender.isSelected ? .on : .off
    }

    @IBAction func finishedTapped(_ sender: UIButton) {
        viewModel.finished().onSuccess { [weak self] identifier in
            guard let self = self else { return }
            `self`.performSegue(withIdentifier: identifier, sender: self)
        }
    }

    @IBAction func albumTapped(_ sender: UIButton) {
        let photoPreviewSheet = ZLPhotoPreviewSheet()
        photoPreviewSheet.selectImageBlock = { [weak self] images, assets, isOriginal in
            guard let self = self, let image = images.first else { return }
            _ = `self`.viewModel.discernMetadataObject(from: image)
            log.info("image: ", context: images)
            log.info("assets: ", context: assets)
            log.info("isOriginal: ", context: isOriginal)
        }
        photoPreviewSheet.showPhotoLibrary(sender: self)
    }
}
