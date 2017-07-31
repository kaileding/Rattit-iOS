//
//  ImagePickerViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/30/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController {
    
    @IBOutlet weak var cameraPreviewView: ReusableCameraView!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var originalSelectedImages: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelComposingImage))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.plain, target: self, action: #selector(confirmImagePickingAndGoNext))
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        let photoCellNib = UINib(nibName: "DevicePhotoCollectionViewCell", bundle: nil)
        self.photoCollectionView.register(photoCellNib, forCellWithReuseIdentifier: "photoCollectionCell")
        
        ComposeContentManager.sharedInstance.updateSelectedPhotoDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.originalSelectedImages = ComposeContentManager.sharedInstance.indexOfCheckedPhotos
        
        let photoCollectionFlowLayout = UICollectionViewFlowLayout()
        let totalWidth = self.view.frame.width
        print("------ in viewWillAppear, totalWidth = \(totalWidth)")
        photoCollectionFlowLayout.itemSize = CGSize(width: 0.25*totalWidth, height: 0.25*totalWidth)
        photoCollectionFlowLayout.minimumInteritemSpacing = 0.0
        photoCollectionFlowLayout.minimumLineSpacing = 0.0
        photoCollectionFlowLayout.scrollDirection = .vertical
        self.photoCollectionView.setCollectionViewLayout(photoCollectionFlowLayout, animated: false)
        self.photoCollectionView.reloadData()
        
        RattitLocationManager.sharedInstance.updateCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.cameraPreviewView.initializeCameraCapture { (capturedImage) in
            print("The capturedImage is ", capturedImage.debugDescription)
            ComposeContentManager.sharedInstance.insertNewPhotoToCollection(newImage: capturedImage)
            self.originalSelectedImages = self.originalSelectedImages.map({ (indexVal) -> Int in
                return indexVal + 1
            })
        }
        
        print("ImagePickerVC, viewDidAppear() func: ")
        print("self.view.frame is ", self.view.frame.debugDescription)
        print("cameraPreviewView.frame is ", self.cameraPreviewView.frame.debugDescription)
        print("photoCollectionView.frame is ", self.photoCollectionView.frame.debugDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func cancelComposingImage() {
        print("cancelComposingImage() func called.")
        ComposeContentManager.sharedInstance.pickedPlaceFromGoogle = nil
        ComposeContentManager.sharedInstance.indexOfCheckedPhotos = self.originalSelectedImages
        self.navigationController?.popViewController(animated: true)
    }
    
    func confirmImagePickingAndGoNext() {
        print("confirmImagePickingAndGoNext() func called.")
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ImagePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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

extension ImagePickerViewController: ComposeContentUpdateSelectedPhotosDelegate {
    func updatePhotoCollectionCells() {
        self.photoCollectionView.reloadData()
    }
}




