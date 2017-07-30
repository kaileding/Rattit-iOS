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
    @IBOutlet weak var placeHolderTextView: ReusablePlaceHolderTextView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var locationLabelCell: UITableViewCell!
    
    @IBOutlet weak var locationIconImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationLabelArrowImageView: UIImageView!
    
    @IBOutlet weak var locationRatingCell: UITableViewCell!
    
    @IBOutlet weak var ratingStarsView: ReusableRatingStarsView!
    
    @IBOutlet weak var separatorCell: UITableViewCell!
    
    @IBOutlet weak var togetherWithCell: UITableViewCell!
    
    @IBOutlet weak var togetherWithIconImageView: UIImageView!
    @IBOutlet weak var togetherWithLabel: UILabel!
    @IBOutlet weak var togetherWithLabelArrowImageView: UIImageView!
    
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
        
        self.titleTextField.delegate = self
        self.placeHolderTextView.setTextView(placeHolder: "Say something", hasTextHandler: {
            if self.titleTextField.text != nil && !self.titleTextField.text!.isEmpty {
                self.enablePostButton()
            }
        }) {
            self.disablePostButton()
        }
        
        self.locationIconImageView.image = UIImage(named: "locationIcon")?.withRenderingMode(.alwaysTemplate)
        self.locationIconImageView.tintColor = UIColor.lightGray
        self.locationLabelArrowImageView.image = UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate)
        self.locationLabelArrowImageView.tintColor = UIColor.lightGray
        
        self.togetherWithIconImageView.image = UIImage(named: "togetherWith")?.withRenderingMode(.alwaysTemplate)
        self.togetherWithIconImageView.tintColor = UIColor.lightGray
        self.togetherWithLabelArrowImageView.image = UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate)
        self.togetherWithLabelArrowImageView.tintColor = UIColor.lightGray
        
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
        
        if self.titleTextField.text == nil || self.titleTextField.text!.isEmpty || self.placeHolderTextView.getCurrentText() == "" {
            self.disablePostButton()
        } else {
            self.enablePostButton()
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
            self.ratingStarsView.setRatingStars(rating: 0, touchHandler: { (newRating) in
                ComposeContentManager.sharedInstance.pickedPlaceRatingValue = newRating
            })
        } else {
            self.locationIconImageView.tintColor = UIColor(red: 0, green: 0.7176, blue: 0.5255, alpha: 1.0)
            self.locationLabel.text = ComposeContentManager.sharedInstance.pickedPlaceFromGoogle!.name
            self.locationLabelArrowImageView.isHidden = true
            
            let currentRatingValue = ComposeContentManager.sharedInstance.pickedPlaceRatingValue
            self.ratingStarsView.setRatingStars(rating: currentRatingValue, touchHandler: { (newRating) in
                ComposeContentManager.sharedInstance.pickedPlaceRatingValue = newRating
            })
        }
        
        self.locationLabelCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        self.locationRatingCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        self.separatorCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        
        self.tableView.reloadData()
        self.displaySelectedShareToCellAndCollapseOptions()
        
        ComposeContentManager.sharedInstance.imagesOfPickedUsersForTogether.forEach({ (pickedUserImageView) in
            pickedUserImageView.removeFromSuperview()
        })
        ComposeContentManager.sharedInstance.imagesOfPickedUsersForTogether.removeAll()
        if ComposeContentManager.sharedInstance.pickedUsersForTogether.isEmpty {
            self.togetherWithLabelArrowImageView.isHidden = false
            self.togetherWithIconImageView.tintColor = UIColor.lightGray
        } else {
            self.togetherWithLabelArrowImageView.isHidden = true
            self.togetherWithIconImageView.tintColor = UIColor(red: 0, green: 0.5098, blue: 0.7882, alpha: 1.0)
            self.showSelectedUsersOnTogetherWithCell()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
        
        ComposeContentManager.sharedInstance.postNewMoment(title: self.titleTextField.text!, words: self.placeHolderTextView.getCurrentText(), completion: {
            
            self.dismiss(animated: true, completion: nil)
        }, errorHandler: {
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}

extension ComposeTextTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text
        let newText = currentText?.replacingCharacters(in: Range<String.Index>(range, in: currentText!)!, with: string)
        if newText != nil && !newText!.isEmpty && self.placeHolderTextView.getCurrentText() != "" {
            self.enablePostButton()
        } else {
            self.disablePostButton()
        }
        
        return true
    }
}

extension ComposeTextTableViewController {
    
    func showSelectedImagesOnScrollView() {
        self.selectedImages = ComposeContentManager.sharedInstance.getSelectedImages()
        let imageCount = self.selectedImages.count
        let canvasFrame = CGRect(x: 0.0, y: 0.0, width: 44.0*Double(imageCount+1), height: 44.0)
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
        
        let buttonFrame = CGRect(x: 44.0*Double(imageCount)+2.0, y: 2.0, width: 40.0, height: 40.0)
        let buttonView = UIButton(frame: buttonFrame)
        buttonView.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonView.tintColor = UIColor.lightGray
        buttonView.clipsToBounds = true
        buttonView.contentMode = .scaleAspectFill
        buttonView.addTarget(self, action: #selector(tapToAddImages), for: .touchUpInside)
        canvasView.addSubview(buttonView)
        
        self.imageScrollView.contentSize = CGSize(width: 44.0*Double(imageCount+1), height: 44.0)
        self.imageScrollView.addSubview(canvasView)
        //        print("self.imageScrollView.frame is \(self.imageScrollView.frame.debugDescription)")
    }
    
    func showSelectedUsersOnTogetherWithCell() {
        let userAvatarStartingX = Double(self.togetherWithLabel.frame.maxX + 8.0)
        let totalWidth = Double(self.view.frame.width)
        ComposeContentManager.sharedInstance.pickedUsersForTogether.enumerated().forEach({ (offset, userId) in
            
            if (userAvatarStartingX+25.0*Double(offset)+30.0) < totalWidth {
                
                let avatarFrame = CGRect(x: userAvatarStartingX+25.0*Double(offset), y: 7.0, width: 30.0, height: 30.0)
                let userAvatar = UIImageView()
                self.togetherWithCell.contentView.addSubview(userAvatar)
                userAvatar.frame = avatarFrame
                userAvatar.layer.cornerRadius = 15.0
                userAvatar.clipsToBounds = true
                userAvatar.contentMode = .scaleAspectFill
                RattitUserManager.sharedInstance.getRattitUserAvatarImage(userId: userId, completion: { (image) in
                    userAvatar.image = image
                }, errorHandler: { (error) in
                    print("RattitUserManager.getRattitUserAvatarImage failed for userId = \(userId)")
                })
                ComposeContentManager.sharedInstance.imagesOfPickedUsersForTogether.append(userAvatar)
            }
        })
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
    
    func enablePostButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        (self.navigationItem.rightBarButtonItem?.customView as! ReusableNavBarItemView).barItemButton.tintColor = RattitStyleColors.clickableButtonBlue
    }
    
    func disablePostButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        (self.navigationItem.rightBarButtonItem?.customView as! ReusableNavBarItemView).barItemButton.tintColor = UIColor.lightGray
    }
    
    func tapToAddImages() {
        print("tapToAddImages() func called.")
        self.navigationController?.popViewController(animated: true)
    }
}


