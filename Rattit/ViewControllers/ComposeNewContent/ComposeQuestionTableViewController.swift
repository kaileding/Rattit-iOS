//
//  ComposeQuestionTableViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/29/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ComposeQuestionTableViewController: UITableViewController {
    
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
    
    let emptyStarImage = UIImage(named: "ratingStar")?.withRenderingMode(.alwaysTemplate)
    let filledStarImage = UIImage(named: "ratingStarFilled")?.withRenderingMode(.alwaysTemplate)
    var locationRatingValue: Int = 0
    var ratingValueForLocation: RattitLocation? = nil
    
    @IBOutlet weak var separatorCell: UITableViewCell!
    
//    @IBOutlet weak var togetherWithCell: UITableViewCell!
//
//    @IBOutlet weak var togetherWithIconImageView: UIImageView!
//    @IBOutlet weak var togetherWithLabel: UILabel!
//    @IBOutlet weak var togetherWithLabelArrowImageView: UIImageView!
    
    @IBOutlet weak var shareToIconImageView: UIImageView!
    @IBOutlet weak var shareToLabel: UILabel!
    @IBOutlet weak var shareToLabelArrowImageView: UIImageView!
    @IBOutlet weak var shareToSelectedLabel: UILabel!
    
    
    @IBOutlet weak var shareToAllCell: UITableViewCell!
    @IBOutlet weak var shareToAllCheckImageView: UIImageView!
    
    @IBOutlet weak var shareToFollowersCell: UITableViewCell!
    @IBOutlet weak var shareToFollowersCheckImageView: UIImageView!
    
    @IBOutlet weak var shareToFriendsCell: UITableViewCell!
    @IBOutlet weak var shareToFriendsCheckImageView: UIImageView!
    
    @IBOutlet weak var shareToPrivateCell: UITableViewCell!
    @IBOutlet weak var shareToPrivateCheckImageView: UIImageView!
    
    var shareToOptionsOpen: Bool = false
    
    
    
    var selectedImages: [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let composeTextRightBarButtonItemView = ReusableNavBarItemView.instantiateFromXib(buttonImageName: "planeTab")
        composeTextRightBarButtonItemView.barItemButton.tintColor = UIColor.lightGray
        composeTextRightBarButtonItemView.setButtonExecutionBlock {
            self.completeTextAndPost()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: composeTextRightBarButtonItemView)
        
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.done, target: self, action: #selector(completeTextAndPost))
        
        self.wordsTextView.delegate = self
        self.wordsTextView.text = "Say something"
        self.wordsTextView.textColor = UIColor.lightGray
        
        self.locationIconImageView.image = UIImage(named: "locationIcon")?.withRenderingMode(.alwaysTemplate)
        self.locationIconImageView.tintColor = UIColor.lightGray
        self.locationLabelArrowImageView.image = UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate)
        self.locationLabelArrowImageView.tintColor = UIColor.lightGray
        
        self.star1ImageView.image = self.emptyStarImage
        self.star1ImageView.tintColor = RattitStyleColors.ratingStarGold
        self.star2ImageView.image = self.emptyStarImage
        self.star2ImageView.tintColor = RattitStyleColors.ratingStarGold
        self.star3ImageView.image = self.emptyStarImage
        self.star3ImageView.tintColor = RattitStyleColors.ratingStarGold
        self.star4ImageView.image = self.emptyStarImage
        self.star4ImageView.tintColor = RattitStyleColors.ratingStarGold
        self.star5ImageView.image = self.emptyStarImage
        self.star5ImageView.tintColor = RattitStyleColors.ratingStarGold
        
        self.shareToIconImageView.image = UIImage(named: "globe")?.withRenderingMode(.alwaysTemplate)
        self.shareToIconImageView.tintColor = UIColor.lightGray
        self.shareToLabelArrowImageView.image = UIImage(named: "downArrow")?.withRenderingMode(.alwaysTemplate)
        self.shareToLabelArrowImageView.tintColor = UIColor.lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.tableHeaderView = UIView()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = RattitStyleColors.backgroundGray
        
        if self.titleTextField.text == nil || self.wordsTextView.textColor == UIColor.lightGray {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        
        self.showSelectedImagesOnScrollView()
        
        RattitLocationManager.sharedInstance.getNearbyPlaces(completion: {
            print("successfully got nearby places from RattitLocationManager.")
        }) { (error) in
            print("Error in getting nearby places from RattitLocationManager. \(error.localizedDescription)")
        }
        
        RattitUserManager.sharedInstance.getAllRattitUsers(completion: {
            print("successfully got all available users from RattitLocationManager.")
        }) { (error) in
            print("Error in getting all available users from RattitLocationManager. \(error.localizedDescription)")
        }
        
        if ComposeContentManager.sharedInstance.pickedPlaceFromGoogle == nil {
            self.locationIconImageView.tintColor = UIColor.lightGray
            self.locationLabel.text = "Location"
            self.locationLabelArrowImageView.isHidden = false
//            self.noStarButtonPressed()
        } else {
            self.locationIconImageView.tintColor = UIColor(red: 0, green: 0.7176, blue: 0.5255, alpha: 1.0)
            self.locationLabel.text = ComposeContentManager.sharedInstance.pickedPlaceFromGoogle!.name
            self.locationLabelArrowImageView.isHidden = true
            
                
//            ComposeContentManager.sharedInstance.pickedPlaceRatingValue
        }
        
        self.locationLabelCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        self.locationRatingCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        self.separatorCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        
        self.tableView.reloadData()
        self.displaySelectedShareToCellAndCollapseOptions()
        
        ComposeContentManager.sharedInstance.imagesOfPickedUsersForTogether.forEach({ (pickedUserImageView) in
            pickedUserImageView.removeFromSuperview()
        })
        
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
        return 9
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
            if self.shareToOptionsOpen {
                self.displaySelectedShareToCellAndCollapseOptions()
            } else {
                self.openShareToOptions()
            }
        } else if indexPath.row == 6 {
            ComposeContentManager.sharedInstance.shareToLevel = .levelPublic
            self.displaySelectedShareToCellAndCollapseOptions()
        } else if indexPath.row == 7 {
            ComposeContentManager.sharedInstance.shareToLevel = .levelFollowers
            self.displaySelectedShareToCellAndCollapseOptions()
        } else if indexPath.row == 8 {
            ComposeContentManager.sharedInstance.shareToLevel = .levelFriends
            self.displaySelectedShareToCellAndCollapseOptions()
        } else if indexPath.row == 9 {
            ComposeContentManager.sharedInstance.shareToLevel = .levelSelf
            self.displaySelectedShareToCellAndCollapseOptions()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 189.0
        } else if indexPath.row == 2 {
            return (ComposeContentManager.sharedInstance.pickedPlaceFromGoogle == nil) ? 0.0 : 44.0
        } else if indexPath.row == 3 {
            return 18.0
        } else if [6, 7, 8, 9].contains(indexPath.row) {
            return self.shareToOptionsOpen ? 44.0 : 0.0
        } else {
            return 44.0
        }
    }
    
    
    
    func completeTextAndPost() {
        
        ComposeContentManager.sharedInstance.postNewMoment(title: self.titleTextField.text!, words: self.wordsTextView.text, completion: {
            
            self.dismiss(animated: true, completion: nil)
        }, errorHandler: {
            
            self.dismiss(animated: true, completion: nil)
        })
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
    
    func displaySelectedShareToCellAndCollapseOptions() {
        //        print("displaySelectedShareToCellAndCollapseOptions(). ")
        self.shareToSelectedLabel.isHidden = false
        self.shareToLabelArrowImageView.isHidden = true
        switch ComposeContentManager.sharedInstance.shareToLevel {
        case .levelPublic:
            self.shareToSelectedLabel.text = "All"
            self.shareToIconImageView.tintColor = UIColor.black
        case .levelFollowers:
            self.shareToSelectedLabel.text = "Followers"
            self.shareToIconImageView.tintColor = UIColor.black
        case .levelFriends:
            self.shareToSelectedLabel.text = "Friends"
            self.shareToIconImageView.tintColor = UIColor.black
        case .levelSelf:
            self.shareToSelectedLabel.text = "Private"
            self.shareToIconImageView.tintColor = UIColor.lightGray
        }
        
        self.shareToOptionsOpen = false
        self.tableView.reloadData()
    }
    
    func openShareToOptions() {
        //        print("openShareToOptions(). ")
        self.shareToSelectedLabel.isHidden = true
        self.shareToLabelArrowImageView.isHidden = false
        
        self.shareToAllCheckImageView.isHidden = true
        self.shareToFollowersCheckImageView.isHidden = true
        self.shareToFriendsCheckImageView.isHidden = true
        self.shareToPrivateCheckImageView.isHidden = true
        switch ComposeContentManager.sharedInstance.shareToLevel {
        case .levelPublic:
            self.shareToAllCheckImageView.isHidden = false
        case .levelFollowers:
            self.shareToFollowersCheckImageView.isHidden = false
        case .levelFriends:
            self.shareToFriendsCheckImageView.isHidden = false
        case .levelSelf:
            self.shareToPrivateCheckImageView.isHidden = false
        }
        
        self.shareToOptionsOpen = true
        self.tableView.reloadData()
    }
}

extension ComposeQuestionTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text
        let newText = currentText?.replacingCharacters(in: Range<String.Index>(range, in: currentText!)!, with: text)
        
        if self.titleTextField.text == nil || self.titleTextField.text!.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            (self.navigationItem.rightBarButtonItem?.customView as! ReusableNavBarItemView).barItemButton.tintColor = UIColor.lightGray
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            (self.navigationItem.rightBarButtonItem?.customView as! ReusableNavBarItemView).barItemButton.tintColor = RattitStyleColors.clickableButtonBlue
        }
        if newText!.isEmpty {
            textView.text = "Say something"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            (self.navigationItem.rightBarButtonItem?.customView as! ReusableNavBarItemView).barItemButton.tintColor = UIColor.lightGray
            
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

