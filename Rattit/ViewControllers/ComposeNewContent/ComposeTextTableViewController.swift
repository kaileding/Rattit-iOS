//
//  ComposeTextTableViewController.swift
//  Rattit
//
//  Created by DINGKaile on 6/28/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ComposeTextTableViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var wordsTextView: UITextView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var locationLabelCell: UITableViewCell!
    
    @IBOutlet weak var locationIconImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationLabelArrowImageView: UIImageView!
    
    @IBOutlet weak var locationRatingCell: UITableViewCell!
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    
    let emptyStarImage = UIImage(named: "ratingStar")?.withRenderingMode(.alwaysTemplate)
    let filledStarImage = UIImage(named: "ratingStarFilled")?.withRenderingMode(.alwaysTemplate)
    
    @IBOutlet weak var separatorCell: UITableViewCell!
    
    @IBOutlet weak var togetherWithIconImageView: UIImageView!
    @IBOutlet weak var togetherWithLabel: UILabel!
    @IBOutlet weak var togetherWithLabelArrowImageView: UIImageView!
    
    @IBOutlet weak var shareToIconImageView: UIImageView!
    @IBOutlet weak var shareToLabel: UILabel!
    
    var selectedImages: [UIImage] = []
    
    let locationRatingView: LocationRatingView = LocationRatingView.instantiateFromXib()
    let stubRatingView: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 266.0, height: 32.0))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.done, target: self, action: #selector(completeTextAndPost))
        
        self.wordsTextView.delegate = self
        self.wordsTextView.text = "Say something"
        self.wordsTextView.textColor = UIColor.lightGray
        
        self.locationIconImageView.image = UIImage(named: "locationIcon")?.withRenderingMode(.alwaysTemplate)
        self.locationIconImageView.tintColor = UIColor.lightGray
        self.locationLabelArrowImageView.image = UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate)
        self.locationLabelArrowImageView.tintColor = UIColor.lightGray
        
        self.star1ImageView.image = self.emptyStarImage
        self.star1ImageView.tintColor = UIColor(red: 0, green: 0.5098, blue: 0.7882, alpha: 1.0)
        self.star2ImageView.image = self.emptyStarImage
        self.star2ImageView.tintColor = UIColor(red: 0, green: 0.5098, blue: 0.7882, alpha: 1.0)
        self.star3ImageView.image = self.emptyStarImage
        self.star3ImageView.tintColor = UIColor(red: 0, green: 0.5098, blue: 0.7882, alpha: 1.0)
        self.star4ImageView.image = self.emptyStarImage
        self.star4ImageView.tintColor = UIColor(red: 0, green: 0.5098, blue: 0.7882, alpha: 1.0)
        self.star5ImageView.image = self.emptyStarImage
        self.star5ImageView.tintColor = UIColor(red: 0, green: 0.5098, blue: 0.7882, alpha: 1.0)
        
        self.star1Button.addTarget(self, action: #selector(star1ButtonPressed), for: .touchDown)
        self.star1Button.addTarget(self, action: #selector(star1ButtonPressed), for: .allTouchEvents)
        self.star2Button.addTarget(self, action: #selector(star2ButtonPressed), for: .touchDown)
        self.star2Button.addTarget(self, action: #selector(star2ButtonPressed), for: .allTouchEvents)
        self.star3Button.addTarget(self, action: #selector(star3ButtonPressed), for: .touchDown)
        self.star3Button.addTarget(self, action: #selector(star3ButtonPressed), for: .allTouchEvents)
        self.star4Button.addTarget(self, action: #selector(star4ButtonPressed), for: .touchDown)
        self.star4Button.addTarget(self, action: #selector(star4ButtonPressed), for: .allTouchEvents)
        self.star5Button.addTarget(self, action: #selector(star5ButtonPressed), for: .touchDown)
        self.star5Button.addTarget(self, action: #selector(star5ButtonPressed), for: .allTouchEvents)
        
        self.togetherWithIconImageView.image = UIImage(named: "togetherWith")?.withRenderingMode(.alwaysTemplate)
        self.togetherWithIconImageView.tintColor = UIColor.lightGray
        self.togetherWithLabelArrowImageView.image = UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate)
        self.togetherWithLabelArrowImageView.tintColor = UIColor.lightGray
        
        self.shareToIconImageView.image = UIImage(named: "globe")?.withRenderingMode(.alwaysTemplate)
        self.shareToIconImageView.tintColor = UIColor.lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.tableHeaderView = UIView()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(red: 0.9255, green: 0.9255, blue: 0.9255, alpha: 1.0)
        
        self.showSelectedImagesOnScrollView()
        
        RattitLocationManager.sharedInstance.getNearbyPlaces(completion: {
            print("successfully got nearby places from RattitLocationManager.")
        }) { (error) in
            print("Error in getting nearby places from RattitLocationManager. \(error.localizedDescription)")
        }
        
        if ComposeContentManager.sharedInstance.pickedPlaceFromGoogle == nil {
            self.locationIconImageView.tintColor = UIColor.lightGray
            self.locationLabel.text = "Location"
            self.locationLabelArrowImageView.isHidden = false
        } else {
            self.locationIconImageView.tintColor = UIColor(red: 0, green: 0.7176, blue: 0.5255, alpha: 1.0)
            self.locationLabel.text = ComposeContentManager.sharedInstance.pickedPlaceFromGoogle!.name
            self.locationLabelArrowImageView.isHidden = true
        }
        
        self.locationLabelCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        self.locationRatingCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        self.separatorCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3 {
            return nil
        } else {
            return indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 { // selected Location row
            performSegue(withIdentifier: "FromComposeTextToLocationPicker", sender: self)
        } else if indexPath.row == 4 {
            performSegue(withIdentifier: "FromComposeTextToTogetherWithFinder", sender: self)
        } else if indexPath.row == 5 {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 189.0
        } else if indexPath.row == 2 {
            return (ComposeContentManager.sharedInstance.pickedPlaceFromGoogle == nil) ? 0.0 : 44.0
        } else if indexPath.row == 3 {
            return 18.0
        } else {
            return 44.0
        }
    }
    
    
    func completeTextAndPost() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showSelectedImagesOnScrollView() {
        self.selectedImages = ComposeContentManager.sharedInstance.getSelectedImages()
        let imageCount = self.selectedImages.count
        let canvasFrame = CGRect(x: 0.0, y: 0.0, width: 44.0*Double(imageCount), height: 44.0)
        let canvasView = UIView(frame: canvasFrame)
        
//        print("self.selectedImages.count = \(self.selectedImages.count)")
//        print("canvasView.frame is \(canvasFrame.debugDescription)")
        
        self.selectedImages.enumerated().forEach { (offset, image) in
            let imageViewFrame = CGRect(x: 44.0*Double(offset)+2.0, y: 2.0, width: 40.0, height: 40.0)
            let imageView = UIImageView(frame: imageViewFrame)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
            canvasView.addSubview(imageView)
        }
        self.imageScrollView.contentSize = CGSize(width: 44.0*Double(imageCount), height: 44.0)
        self.imageScrollView.addSubview(canvasView)
//        print("self.imageScrollView.frame is \(self.imageScrollView.frame.debugDescription)")
    }
}


extension ComposeTextTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text
        let newText = currentText?.replacingCharacters(in: Range<String.Index>(range, in: currentText!)!, with: text)
        
        if newText!.isEmpty {
            textView.text = "Say something"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
}

extension ComposeTextTableViewController {
    
    func star1ButtonPressed() {
        print("star-1-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.emptyStarImage
        self.star3ImageView.image = self.emptyStarImage
        self.star4ImageView.image = self.emptyStarImage
        self.star5ImageView.image = self.emptyStarImage
        
    }
    
    func star2ButtonPressed() {
        print("star-2-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.emptyStarImage
        self.star4ImageView.image = self.emptyStarImage
        self.star5ImageView.image = self.emptyStarImage
        
    }
    
    func star3ButtonPressed() {
        print("star-3-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.filledStarImage
        self.star4ImageView.image = self.emptyStarImage
        self.star5ImageView.image = self.emptyStarImage
        
    }
    
    func star4ButtonPressed() {
        print("star-4-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.filledStarImage
        self.star4ImageView.image = self.filledStarImage
        self.star5ImageView.image = self.emptyStarImage
        
    }
    
    func star5ButtonPressed() {
        print("star-5-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.filledStarImage
        self.star4ImageView.image = self.filledStarImage
        self.star5ImageView.image = self.filledStarImage
        
    }
    
}


