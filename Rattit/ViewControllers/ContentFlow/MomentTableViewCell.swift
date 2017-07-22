//
//  MomentTableViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class MomentTableViewCell: UITableViewCell {
    
    var momentHeaderView: MainContentHeaderView! = MainContentHeaderView.instantiateFromXib()
    
    var momentTitleWordsView: ContentTitleWordsView! = ContentTitleWordsView.instantiateFromXib()
    
    var momentPhotoScrollView: PhotoScrollView! = PhotoScrollView.instantiateFromXib()
    
    var momentOptionBar: MomentOptionBar! = MomentOptionBar.instantiateFromXib()
    
    var titleWordsViewTopToHeaderViewConstraint: NSLayoutConstraint? = nil
    var photoScrollViewBottomToTitleWordsViewConstraint: NSLayoutConstraint? = nil
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
        
        // setup momentTitleWordsView
        self.momentTitleWordsView.translatesAutoresizingMaskIntoConstraints = false
        self.momentTitleWordsView.removeFromSuperview()
        self.contentView.addSubview(self.momentTitleWordsView)
        
        self.momentTitleWordsView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8.0).isActive = true
        self.momentTitleWordsView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8.0).isActive = true
        self.titleWordsViewTopToHeaderViewConstraint = NSLayoutConstraint(item: self.momentTitleWordsView, attribute: .top, relatedBy: .equal, toItem: self.momentHeaderView, attribute: .bottomMargin, multiplier: 1.0, constant: 10.0)
        
        // setup momentPhotoScrollView
        self.momentPhotoScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.photoScrollViewTopToHeaderViewConstraint = NSLayoutConstraint(item: self.momentPhotoScrollView, attribute: .top, relatedBy: .equal, toItem: self.momentHeaderView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.photoScrollViewBottomToTitleWordsViewConstraint = NSLayoutConstraint(item: self.momentPhotoScrollView, attribute: .bottom, relatedBy: .equal, toItem: self.momentTitleWordsView, attribute: .top, multiplier: 1.0, constant: -8.0)
        
        // setup momentOptionBar
        self.momentOptionBar.translatesAutoresizingMaskIntoConstraints = false
        self.momentOptionBar.removeFromSuperview()
        self.contentView.addSubview(self.momentOptionBar)
        self.momentOptionBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8.0).isActive = true
        self.momentOptionBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8.0).isActive = true
        self.momentOptionBar.topAnchor.constraint(equalTo: self.momentTitleWordsView.bottomAnchor, constant: 0.0).isActive = true
        self.momentOptionBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0.0).isActive = true
        let momentOptionBarHeightConstraint = self.momentOptionBar.heightAnchor.constraint(equalToConstant: 38.0)
        momentOptionBarHeightConstraint.priority = 999
        momentOptionBarHeightConstraint.isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func initializeContent(moment: Moment, sideLength: Double) {
        
        self.momentHeaderView.initializeData(mainContent: moment as MainContent)
        self.momentTitleWordsView.initializeData(title: moment.title, words: moment.words)
        self.momentOptionBar.initializeData(moment: moment)
        
        if let photos = moment.photos, photos.count > 0 {
            self.titleWordsViewTopToHeaderViewConstraint?.isActive = false
            
            self.momentPhotoScrollView.removeFromSuperview()
            self.contentView.addSubview(self.momentPhotoScrollView)
            
            let margins = self.contentView.layoutMarginsGuide
            self.momentPhotoScrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8.0).isActive = true
            self.momentPhotoScrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8.0).isActive = true
            let aspectRatioConstraint = NSLayoutConstraint(item: self.momentPhotoScrollView, attribute: .height, relatedBy: .equal, toItem: self.momentPhotoScrollView, attribute: .width, multiplier: 0.6, constant: 0.0)
            aspectRatioConstraint.priority = 999
            aspectRatioConstraint.isActive = true
            
            self.photoScrollViewTopToHeaderViewConstraint?.isActive = true
            self.photoScrollViewBottomToTitleWordsViewConstraint?.isActive = true
            
            self.momentPhotoScrollView.sizeToFit()
            self.momentTitleWordsView.sizeToFit()
            
            self.momentPhotoScrollView?.initializeData(photos: photos, sideLength: sideLength)
        } else {
            self.photoScrollViewTopToHeaderViewConstraint?.isActive = false
            self.photoScrollViewBottomToTitleWordsViewConstraint?.isActive = false
            
            self.momentPhotoScrollView.removeFromSuperview()
            
            self.titleWordsViewTopToHeaderViewConstraint?.isActive = true
        }
        
    }
    
    
}
