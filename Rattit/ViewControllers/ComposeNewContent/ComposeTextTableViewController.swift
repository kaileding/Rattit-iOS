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
    
    let emptyStarImage = UIImage(named: "ratingStar")?.withRenderingMode(.alwaysTemplate)
    let filledStarImage = UIImage(named: "ratingStarFilled")?.withRenderingMode(.alwaysTemplate)
    var locationRatingValue: Int = 0
    var ratingValueForLocation: RattitLocation? = nil
    
    @IBOutlet weak var separatorCell: UITableViewCell!
    
    @IBOutlet weak var togetherWithCell: UITableViewCell!
    
    @IBOutlet weak var togetherWithIconImageView: UIImageView!
    @IBOutlet weak var togetherWithLabel: UILabel!
    @IBOutlet weak var togetherWithLabelArrowImageView: UIImageView!
    
    @IBOutlet weak var shareToIconImageView: UIImageView!
    @IBOutlet weak var shareToLabel: UILabel!
    @IBOutlet weak var shareToLabelArrowImageView: UIImageView!
    
    var selectedImages: [UIImage] = []
    
    
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
        self.tableView.backgroundColor = UIColor(red: 0.9255, green: 0.9255, blue: 0.9255, alpha: 1.0)
        
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
            self.noStarButtonPressed()
        } else {
            self.locationIconImageView.tintColor = UIColor(red: 0, green: 0.7176, blue: 0.5255, alpha: 1.0)
            self.locationLabel.text = ComposeContentManager.sharedInstance.pickedPlaceFromGoogle!.name
            self.locationLabelArrowImageView.isHidden = true
            
            switch ComposeContentManager.sharedInstance.pickedPlaceRatingValue {
            case 0:
                self.noStarButtonPressed()
            case 1:
                self.star1ButtonPressed()
            case 2:
                self.star2ButtonPressed()
            case 3:
                self.star3ButtonPressed()
            case 4:
                self.star4ButtonPressed()
            case 5:
                self.star5ButtonPressed()
            default:
                self.noStarButtonPressed()
            }
        }
        
        self.locationLabelCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        self.locationRatingCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        self.separatorCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.frame.width)
        
        self.tableView.reloadData()
        
        ComposeContentManager.sharedInstance.imagesOfPickedUsersForTogether.forEach({ (pickedUserImageView) in
            pickedUserImageView.removeFromSuperview()
        })
        ComposeContentManager.sharedInstance.imagesOfPickedUsersForTogether.removeAll()
        if ComposeContentManager.sharedInstance.pickedUsersForTogether.isEmpty {
            self.togetherWithLabelArrowImageView.isHidden = false
        } else {
            self.togetherWithLabelArrowImageView.isHidden = true
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
    
    
    
    @IBAction func tapGestureInLocationRatingCell(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self.locationRatingCell.contentView)
        let width = self.tableView.frame.width
//        print("TAP - tapPoint.x = \(tapPoint.x)")
        
        if tapPoint.x < (0.5*width - 54.0) {
            self.star1ButtonPressed()
        } else if tapPoint.x < (0.5*width - 18.0) {
            self.star2ButtonPressed()
        } else if tapPoint.x < (0.5*width + 18.0) {
            self.star3ButtonPressed()
        } else if tapPoint.x < (0.5*width + 54.0) {
            self.star4ButtonPressed()
        } else {
            self.star5ButtonPressed()
        }
    }
    
    @IBAction func panGestureInLocationRatingCell(_ sender: UIPanGestureRecognizer) {
        let panPoint = sender.location(in: self.locationRatingCell.contentView)
        let width = self.tableView.frame.width
//        print("PAN - panPoint.x = \(panPoint.x)")
        
        if panPoint.x < (0.5*width - 54.0) {
            self.star1ButtonPressed()
        } else if panPoint.x < (0.5*width - 18.0) {
            self.star2ButtonPressed()
        } else if panPoint.x < (0.5*width + 18.0) {
            self.star3ButtonPressed()
        } else if panPoint.x < (0.5*width + 54.0) {
            self.star4ButtonPressed()
        } else {
            self.star5ButtonPressed()
        }
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
    
    func noStarButtonPressed() {
        print("no stars are touched.")
        self.star1ImageView.image = self.emptyStarImage
        self.star2ImageView.image = self.emptyStarImage
        self.star3ImageView.image = self.emptyStarImage
        self.star4ImageView.image = self.emptyStarImage
        self.star5ImageView.image = self.emptyStarImage
        ComposeContentManager.sharedInstance.pickedPlaceRatingValue = 0
    }
    
    func star1ButtonPressed() {
        print("star-1-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.emptyStarImage
        self.star3ImageView.image = self.emptyStarImage
        self.star4ImageView.image = self.emptyStarImage
        self.star5ImageView.image = self.emptyStarImage
        ComposeContentManager.sharedInstance.pickedPlaceRatingValue = 1
    }
    
    func star2ButtonPressed() {
        print("star-2-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.emptyStarImage
        self.star4ImageView.image = self.emptyStarImage
        self.star5ImageView.image = self.emptyStarImage
        ComposeContentManager.sharedInstance.pickedPlaceRatingValue = 2
    }
    
    func star3ButtonPressed() {
        print("star-3-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.filledStarImage
        self.star4ImageView.image = self.emptyStarImage
        self.star5ImageView.image = self.emptyStarImage
        ComposeContentManager.sharedInstance.pickedPlaceRatingValue = 3
    }
    
    func star4ButtonPressed() {
        print("star-4-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.filledStarImage
        self.star4ImageView.image = self.filledStarImage
        self.star5ImageView.image = self.emptyStarImage
        ComposeContentManager.sharedInstance.pickedPlaceRatingValue = 4
    }
    
    func star5ButtonPressed() {
        print("star-5-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.filledStarImage
        self.star4ImageView.image = self.filledStarImage
        self.star5ImageView.image = self.filledStarImage
        ComposeContentManager.sharedInstance.pickedPlaceRatingValue = 5
    }
}


