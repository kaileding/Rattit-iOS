//
//  MomentTableViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class MomentTableViewCell: UITableViewCell {
    
    var momentHeaderView: MomentHeaderView! = MomentHeaderView.instantiateFromXib()
    
    var momentWordsLabel: UILabel! = UILabel()
    
    var momentPhotoScrollView: PhotoScrollView! = PhotoScrollView.instantiateFromXib()
    
    var wordsLabelBottomToSuperViewConstraint: NSLayoutConstraint? = nil
    var photoScrollViewBottomToSuperViewConstraint: NSLayoutConstraint? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // UI Initialization code
        
        // setup momentHeaderView
        self.momentHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.momentHeaderView.removeFromSuperview()
        self.contentView.addSubview(self.momentHeaderView)
        let margins = self.contentView.layoutMarginsGuide
        self.momentHeaderView?.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.momentHeaderView?.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.momentHeaderView?.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        
        // setup momentWordsLabel
        self.momentWordsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.momentWordsLabel.numberOfLines = 4
        self.momentWordsLabel.font = UIFont(name: "Helvetica", size: 14.0)
        self.momentWordsLabel.textColor = UIColor.darkText
        self.contentView.addSubview(self.momentWordsLabel)
        self.momentWordsLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 44.0).isActive = true
        self.momentWordsLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.momentWordsLabel.topAnchor.constraint(greaterThanOrEqualTo: self.momentHeaderView.bottomAnchor).isActive = true
        self.wordsLabelBottomToSuperViewConstraint = NSLayoutConstraint(item: self.momentWordsLabel, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0)
        self.wordsLabelBottomToSuperViewConstraint?.isActive = true
        
        // setup momentPhotoScrollView
        self.momentPhotoScrollView.translatesAutoresizingMaskIntoConstraints = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func initializeContent(moment: Moment, sideLength: Double) {
        
        self.momentHeaderView?.initializeData(moment: moment)
        self.momentWordsLabel.text = moment.words
        
        if let photos = moment.photos, photos.count > 0 {
            self.momentPhotoScrollView.removeFromSuperview()
            self.contentView.addSubview(self.momentPhotoScrollView)
            let margins = self.contentView.layoutMarginsGuide
            self.momentPhotoScrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8.0).isActive = true
            self.momentPhotoScrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8.0).isActive = true
            self.momentPhotoScrollView.topAnchor.constraint(equalTo: self.momentWordsLabel.bottomAnchor, constant: 2.0).isActive = true
            self.momentPhotoScrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0.0).isActive = true
            self.wordsLabelBottomToSuperViewConstraint?.isActive = false
            self.photoScrollViewBottomToSuperViewConstraint = NSLayoutConstraint(item: self.momentPhotoScrollView, attribute: .height, relatedBy: .equal, toItem: self.momentPhotoScrollView, attribute: .width, multiplier: 1.0, constant: 0.0)
            self.photoScrollViewBottomToSuperViewConstraint?.isActive = true
            self.momentPhotoScrollView.sizeToFit()
            
            self.momentPhotoScrollView?.initializeData(photos: photos, sideLength: sideLength)
        } else {
            self.momentPhotoScrollView.removeFromSuperview()
            self.photoScrollViewBottomToSuperViewConstraint?.isActive = false
            self.wordsLabelBottomToSuperViewConstraint?.isActive = true
        }
        
    }
    
    
}
