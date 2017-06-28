//
//  ComposeImageViewController.swift
//  Rattit
//
//  Created by DINGKaile on 6/23/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ComposeImageViewController: UIViewController {
    
    @IBOutlet weak var photoPreviewView: UIView!
    
    var photoCaptureImageView: CapturedPhotoView! = CapturedPhotoView.instantiateFromXib()
    
    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var rotateCameraButton: UIButton!
    @IBOutlet weak var changeFlashButton: UIButton!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    
    var avCaptureSession: AVCaptureSession = AVCaptureSession()
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var isUsingRearCamera: Bool = true
    var frontCameraDevice: AVCaptureDevice? = nil
    var frontCameraInput: AVCaptureInput? = nil
    var backCameraDevice: AVCaptureDevice? = nil
    var backCameraInput: AVCaptureInput? = nil
    var captureInitializationDone: Bool = false
    
    
    let shutterButtonImage = UIImage(named: "shutterButton")?.withRenderingMode(.alwaysTemplate)
    let rotateButtonImage = UIImage(named: "180rotate")?.withRenderingMode(.alwaysTemplate)
    let flashAutoButtonImage = UIImage(named: "flashAuto")?.withRenderingMode(.alwaysTemplate)
    let flashNoButtonImage = UIImage(named: "flashNo")?.withRenderingMode(.alwaysTemplate)
    let flashYesButtonImage = UIImage(named: "flashYes")?.withRenderingMode(.alwaysTemplate)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.photoPreviewView.backgroundColor = UIColor.darkGray
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 30.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelComposingImage))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(confirmImagePickingAndGoNext))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.shutterButton.setImage(shutterButtonImage, for: .normal)
        self.shutterButton.tintColor = UIColor.white
        self.shutterButton.addTarget(self, action: #selector(shutterButtonPressed), for: .touchUpInside)
        
        self.rotateCameraButton.setImage(rotateButtonImage, for: .normal)
        self.rotateCameraButton.tintColor = UIColor.white
        self.rotateCameraButton.addTarget(self, action: #selector(rotateCameraButtonPressed), for: .touchUpInside)
        
        self.changeFlashButton.setImage(flashAutoButtonImage, for: .normal)
        self.changeFlashButton.tintColor = UIColor.white
        self.changeFlashButton.addTarget(self, action: #selector(changeFlashButtonPressed), for: .touchUpInside)
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        let photoCellNib = UINib(nibName: "DevicePhotoCollectionViewCell", bundle: nil)
        self.photoCollectionView.register(photoCellNib, forCellWithReuseIdentifier: "photoCollectionCell")
        
        ComposeContentManager.sharedInstance.composeContentDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ComposeContentManager.sharedInstance.indexOfCheckedPhotos = []
        
        let photoCollectionFlowLayout = UICollectionViewFlowLayout()
        let totalWidth = self.view.frame.width
        print("------ in viewWillAppear, totalWidth = \(totalWidth)")
        photoCollectionFlowLayout.itemSize = CGSize(width: 0.25*totalWidth, height: 0.25*totalWidth)
        photoCollectionFlowLayout.minimumInteritemSpacing = 0.0
        photoCollectionFlowLayout.minimumLineSpacing = 0.0
        photoCollectionFlowLayout.scrollDirection = .vertical
        self.photoCollectionView.setCollectionViewLayout(photoCollectionFlowLayout, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.captureInitializationDone {
            self.initializeCameraPreview()
            self.attachCameraInput()
            self.avCaptureSession.startRunning()
            self.captureInitializationDone = true
        }
        if !self.avCaptureSession.isRunning {
            self.avCaptureSession.startRunning()
        }
        
        self.photoCollectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.avCaptureSession.stopRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initializeCameraPreview() {
        self.avCaptureSession.sessionPreset = AVCaptureSessionPresetPhoto
        self.frontCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        self.backCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        do {
            self.frontCameraInput = try AVCaptureDeviceInput(device: self.frontCameraDevice)
            self.backCameraInput = try AVCaptureDeviceInput(device: self.backCameraDevice)
            
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
            self.videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.photoPreviewView.layer.masksToBounds = true
            self.photoPreviewView.layer.insertSublayer(self.videoPreviewLayer!, below: self.shutterButton.layer)
            //            self.photoPreviewView.layer.addSublayer(self.videoPreviewLayer!)
            self.videoPreviewLayer?.frame = self.photoPreviewView.bounds
            
            self.stillImageOutput = AVCapturePhotoOutput()
            let outputVideoCode = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
            self.stillImageOutput?.setPreparedPhotoSettingsArray([outputVideoCode], completionHandler: { (success, error) in
                print("setPreparePhotoSettingsArray success: \(success)")
            })
            
            if self.avCaptureSession.canAddOutput(self.stillImageOutput) {
                self.avCaptureSession.addOutput(self.stillImageOutput)
            }
        } catch {
            print("xxxxxx --- Unable to use camera.")
        }
        
    }
    
    func attachCameraInput() {
        if self.isUsingRearCamera && (self.backCameraInput != nil) && (self.frontCameraInput != nil) {
            self.avCaptureSession.removeInput(self.frontCameraInput!)
            if self.avCaptureSession.canAddInput(self.backCameraInput!) {
                self.avCaptureSession.addInput(self.backCameraInput!)
                self.setFlashButtonBasedOnTorchMode(cameraDevice: self.backCameraDevice!)
                print("--- using rear camera.")
            } else {
                print("--- cannot add backCameraInput.")
            }
        } else if (self.isUsingRearCamera == false) && (self.frontCameraInput != nil) && (self.backCameraInput != nil) {
            self.avCaptureSession.removeInput(self.backCameraInput!)
            if self.avCaptureSession.canAddInput(self.frontCameraInput!) {
                self.avCaptureSession.addInput(self.frontCameraInput!)
                self.setFlashButtonBasedOnTorchMode(cameraDevice: self.frontCameraDevice!)
                print("--- using front camera.")
            } else {
                print("--- cannot add frontCameraInput.")
            }
        }
    }
    
    
    
    func cancelComposingImage() {
        print("cancelComposingImage() func called.")
        self.dismiss(animated: true, completion: nil)
    }
    
    func confirmImagePickingAndGoNext() {
        print("confirmImagePickingAndGoNext() func called.")
        
//        ComposeContentManager.sharedInstance.uploadSelectedImagesToServer()
        
        performSegue(withIdentifier: "FromComposeImageToComposeText", sender: self)
    }
    
    func shutterButtonPressed() {
        print("shutterButtonPressed called.")
        let outputVideoCode = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
        self.stillImageOutput?.capturePhoto(with: outputVideoCode, delegate: self)
    }
    
    func rotateCameraButtonPressed() {
        print("rotateCameraButtonPressed called.")
        
        self.isUsingRearCamera = !self.isUsingRearCamera
        if self.isUsingRearCamera && (self.backCameraDevice != nil) {
            if self.backCameraDevice!.hasTorch {
                self.changeFlashButton.isHidden = false
            } else {
                self.changeFlashButton.isHidden = true
            }
            self.attachCameraInput()
        } else if !self.isUsingRearCamera && (self.frontCameraDevice != nil) {
            if self.frontCameraDevice!.hasTorch {
                self.changeFlashButton.isHidden = false
            } else {
                self.changeFlashButton.isHidden = true
            }
            self.attachCameraInput()
        }
    }
    
    func changeFlashButtonPressed() {
        print("changeFlashButtonPressed called.")
        
        if self.isUsingRearCamera && (self.backCameraDevice != nil) {
            if self.backCameraDevice!.hasTorch {
                self.switchTorchMode(cameraDevice: self.backCameraDevice!)
            }
        } else if !self.isUsingRearCamera && (self.frontCameraDevice != nil) {
            if self.frontCameraDevice!.hasTorch {
                self.switchTorchMode(cameraDevice: self.frontCameraDevice!)
            }
        }
    }
    
    func switchTorchMode(cameraDevice: AVCaptureDevice) {
        do {
            let _ = try cameraDevice.lockForConfiguration()
            let newModeCode = (cameraDevice.torchMode.rawValue + 1) > 2 ? 0 : (cameraDevice.torchMode.rawValue + 1)
            cameraDevice.torchMode = AVCaptureDevice.TorchMode(rawValue: newModeCode)!
            
            self.setFlashButtonBasedOnTorchMode(cameraDevice: cameraDevice)
            cameraDevice.unlockForConfiguration()
        } catch {
            print("Unable to lock device for configuration.")
        }
    }
    
    func setFlashButtonBasedOnTorchMode(cameraDevice: AVCaptureDevice) {
        print("--- cameraDevice.torchMode = ", cameraDevice.torchMode.rawValue)
        switch cameraDevice.torchMode {
        case AVCaptureDevice.TorchMode.off:
            self.changeFlashButton.setImage(self.flashNoButtonImage, for: .normal)
        case AVCaptureDevice.TorchMode.auto:
            self.changeFlashButton.setImage(self.flashAutoButtonImage, for: .normal)
        case AVCaptureDevice.TorchMode.on:
            self.changeFlashButton.setImage(self.flashYesButtonImage, for: .normal)
        }
        self.changeFlashButton.tintColor = UIColor.white
    }
    
}

extension ComposeImageViewController: AVCapturePhotoCaptureDelegate {
    
    func capture(_ output: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if photoSampleBuffer != nil {
            if let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: nil) {
                if let capturedImage = UIImage(data: imageData) {
                    print("===== success got the image. image.size is ", capturedImage.size.debugDescription)
                    
                    self.photoCaptureImageView.removeFromSuperview()
                    self.photoPreviewView.addSubview(self.photoCaptureImageView)
                    self.photoCaptureImageView.translatesAutoresizingMaskIntoConstraints = false
                    self.photoCaptureImageView.leadingAnchor.constraint(equalTo: self.photoPreviewView.leadingAnchor, constant: 0.0).isActive = true
                    self.photoCaptureImageView.trailingAnchor.constraint(equalTo: self.photoPreviewView.trailingAnchor, constant: 0.0).isActive = true
                    self.photoCaptureImageView.topAnchor.constraint(equalTo: self.photoPreviewView.topAnchor, constant: 0.0).isActive = true
                    self.photoCaptureImageView.bottomAnchor.constraint(equalTo: self.photoPreviewView.bottomAnchor, constant: 0.0).isActive = true
                    self.photoCaptureImageView.layoutIfNeeded()
                    self.photoCaptureImageView.initializeContent(image: capturedImage)
                    self.photoCaptureImageView.sizeToFit()
                    
                }
                
            }
        }
    }
}

extension ComposeImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ComposeContentManager.sharedInstance.imageOfPhotosOnDevice.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionCell", for: indexPath) as! DevicePhotoCollectionViewCell
        
        cellView.initializeData(assetIndex: indexPath.row)
        
        return cellView
    }
    
}

extension ComposeImageViewController: ComposeContentDelegate {
    func updatePhotoCollectionCells() {
        self.photoCollectionView.reloadData()
        if ComposeContentManager.sharedInstance.hasAtLeastOneImageChecked() {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}



