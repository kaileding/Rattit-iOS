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
    
    @IBOutlet weak var cameraPreviewView: ReusableCameraView!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 30.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelComposingImage))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(confirmImagePickingAndGoNext))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        let photoCellNib = UINib(nibName: "DevicePhotoCollectionViewCell", bundle: nil)
        self.photoCollectionView.register(photoCellNib, forCellWithReuseIdentifier: "photoCollectionCell")
        
        ComposeContentManager.sharedInstance.updateSelectedPhotoDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let photoCollectionFlowLayout = UICollectionViewFlowLayout()
        let totalWidth = self.view.frame.width
        print("------ in viewWillAppear, totalWidth = \(totalWidth)")
        photoCollectionFlowLayout.itemSize = CGSize(width: 0.25*totalWidth, height: 0.25*totalWidth)
        photoCollectionFlowLayout.minimumInteritemSpacing = 0.0
        photoCollectionFlowLayout.minimumLineSpacing = 0.0
        photoCollectionFlowLayout.scrollDirection = .vertical
        self.photoCollectionView.setCollectionViewLayout(photoCollectionFlowLayout, animated: false)
        self.photoCollectionView.reloadData()
        if ComposeContentManager.sharedInstance.hasAtLeastOneImageChecked() {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        RattitLocationManager.sharedInstance.updateCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.cameraPreviewView.initializeCameraCapture { (capturedImage) in
            print("The capturedImage is ", capturedImage.debugDescription)
            ComposeContentManager.sharedInstance.insertNewPhotoToCollection(newImage: capturedImage)
        }
        
        print("ComposeImageVC, viewDidAppear() func: cameraPreviewView.frame is ", self.cameraPreviewView.frame.debugDescription)
        print("ComposeImageVC, viewDidAppear() func: photoCollectionView.frame is ", self.photoCollectionView.frame.debugDescription)
        print("ComposeImageVC, viewDidAppear() func: photoCollectionView.contentSize is ", self.photoCollectionView.contentSize.debugDescription)
        print("ComposeImageVC, viewDidAppear() func: photoCollectionView.contentOffset is ", self.photoCollectionView.contentOffset.debugDescription)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func cancelComposingImage() {
        print("cancelComposingImage() func called.")
        ComposeContentManager.sharedInstance.pickedPlaceFromGoogle = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    func confirmImagePickingAndGoNext() {
        print("confirmImagePickingAndGoNext() func called.")
        
        performSegue(withIdentifier: "FromComposeImageToComposeText", sender: self)
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

extension ComposeImageViewController: ComposeContentUpdateSelectedPhotosDelegate {
    func updatePhotoCollectionCells() {
        self.photoCollectionView.reloadData()
        if ComposeContentManager.sharedInstance.hasAtLeastOneImageChecked() {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}



