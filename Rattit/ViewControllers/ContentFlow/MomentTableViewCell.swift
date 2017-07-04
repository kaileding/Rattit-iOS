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
    
    var momentOptionBar: MomentOptionBar! = MomentOptionBar.instantiateFromXib()
    
    var wordsLabelTopToHeaderViewConstraint: NSLayoutConstraint? = nil
    var photoScrollViewBottomToWordsLabelConstraint: NSLayoutConstraint? = nil
    var photoScrollViewTopToHeaderViewConstraint: NSLayoutConstraint? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // UI Initialization code
        
        let margins = self.contentView.layoutMarginsGuide
        // setup momentHeaderView
        self.momentHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.momentHeaderView.removeFromSuperview()
        self.contentView.addSubview(self.momentHeaderView)
        self.momentHeaderView?.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.momentHeaderView?.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.momentHeaderView?.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        // setup momentWordsLabel
        self.momentWordsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.momentWordsLabel.numberOfLines = 4
        self.momentWordsLabel.font = UIFont(name: "Helvetica", size: 14.0)
        self.momentWordsLabel.textColor = UIColor.darkText
        self.momentWordsLabel.removeFromSuperview()
        self.contentView.addSubview(self.momentWordsLabel)
        self.momentWordsLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 8.0).isActive = true
        self.momentWordsLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8.0).isActive = true
        self.wordsLabelTopToHeaderViewConstraint = NSLayoutConstraint(item: self.momentWordsLabel, attribute: .top, relatedBy: .equal, toItem: self.momentHeaderView, attribute: .bottomMargin, multiplier: 1.0, constant: 10.0)
        
        // setup momentPhotoScrollView
        self.momentPhotoScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.photoScrollViewTopToHeaderViewConstraint = NSLayoutConstraint(item: self.momentPhotoScrollView, attribute: .top, relatedBy: .equal, toItem: self.momentHeaderView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.photoScrollViewBottomToWordsLabelConstraint = NSLayoutConstraint(item: self.momentPhotoScrollView, attribute: .bottom, relatedBy: .equal, toItem: self.momentWordsLabel, attribute: .top, multiplier: 1.0, constant: -8.0)
        
        // setup momentOptionBar
        self.momentOptionBar.translatesAutoresizingMaskIntoConstraints = false
        self.momentOptionBar.removeFromSuperview()
        self.contentView.addSubview(self.momentOptionBar)
        self.momentOptionBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8.0).isActive = true
        self.momentOptionBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8.0).isActive = true
        self.momentOptionBar.topAnchor.constraint(equalTo: self.momentWordsLabel.bottomAnchor, constant: 0.0).isActive = true
        self.momentOptionBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0.0).isActive = true
        let momentOptionBarHeightConstraint = self.momentOptionBar.heightAnchor.constraint(equalToConstant: 38.0)
        momentOptionBarHeightConstraint.priority = 999
        momentOptionBarHeightConstraint.isActive = true
        
//        self.momentOptionBar.heightAnchor.constraint(equalToConstant: 38.0).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func initializeContent(moment: Moment, sideLength: Double) {
        
        self.momentHeaderView?.initializeData(moment: moment)
        self.momentWordsLabel.text = moment.words
        
        if let photos = moment.photos, photos.count > 0 {
            self.wordsLabelTopToHeaderViewConstraint?.isActive = false
            
            self.momentPhotoScrollView.removeFromSuperview()
            self.contentView.addSubview(self.momentPhotoScrollView)
            
            let margins = self.contentView.layoutMarginsGuide
            self.momentPhotoScrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8.0).isActive = true
            self.momentPhotoScrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8.0).isActive = true
            let aspectRatioConstraint = NSLayoutConstraint(item: self.momentPhotoScrollView, attribute: .width, relatedBy: .equal, toItem: self.momentPhotoScrollView, attribute: .height, multiplier: 1.0, constant: 0.0)
            aspectRatioConstraint.priority = 999
            aspectRatioConstraint.isActive = true
            
            self.photoScrollViewTopToHeaderViewConstraint?.isActive = true
            self.photoScrollViewBottomToWordsLabelConstraint?.isActive = true
            
            self.momentPhotoScrollView.sizeToFit()
            self.momentWordsLabel.sizeToFit()
            
            self.momentPhotoScrollView?.initializeData(photos: photos, sideLength: sideLength)
        } else {
            self.photoScrollViewTopToHeaderViewConstraint?.isActive = false
            self.photoScrollViewBottomToWordsLabelConstraint?.isActive = false
            
            self.momentPhotoScrollView.removeFromSuperview()
            
            self.wordsLabelTopToHeaderViewConstraint?.isActive = true
            
        }
        
    }
    
    
}
