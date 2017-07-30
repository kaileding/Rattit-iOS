//
//  ReusableRatingStarsView.swift
//  Rattit
//
//  Created by DINGKaile on 7/29/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ReusableRatingStarsView: UIView {
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    let emptyStarImage = UIImage(named: "ratingStar")?.withRenderingMode(.alwaysTemplate)
    let filledStarImage = UIImage(named: "ratingStarFilled")?.withRenderingMode(.alwaysTemplate)
    var task: ((Int) -> Void)? = nil
    
    override func awakeFromNib() {
        let reusableRatingStarsView = Bundle.main.loadNibNamed("ReusableRatingStarsView", owner: self, options: nil)?.first as! UIView
        
        reusableRatingStarsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(reusableRatingStarsView)
        reusableRatingStarsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        reusableRatingStarsView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        reusableRatingStarsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        reusableRatingStarsView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        
        self.star1ImageView.tintColor = RattitStyleColors.ratingStarGold
        self.star2ImageView.tintColor = RattitStyleColors.ratingStarGold
        self.star3ImageView.tintColor = RattitStyleColors.ratingStarGold
        self.star4ImageView.tintColor = RattitStyleColors.ratingStarGold
        self.star5ImageView.tintColor = RattitStyleColors.ratingStarGold
        
        self.noStarButtonPressed()
    }
    
    func setRatingStars(rating: Int, touchHandler: @escaping (Int) -> Void) {
        self.task = touchHandler
        
        switch rating {
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
    
    
    @IBAction func tapGestureInLocationRatingCell(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self)
        let width = self.frame.width
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
        let panPoint = sender.location(in: self)
        let width = self.frame.width
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


extension ReusableRatingStarsView {
    
    func noStarButtonPressed() {
        print("no stars are touched.")
        self.star1ImageView.image = self.emptyStarImage
        self.star2ImageView.image = self.emptyStarImage
        self.star3ImageView.image = self.emptyStarImage
        self.star4ImageView.image = self.emptyStarImage
        self.star5ImageView.image = self.emptyStarImage
        if self.task != nil {
            self.task!(0)
        }
    }
    
    func star1ButtonPressed() {
        print("star-1-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.emptyStarImage
        self.star3ImageView.image = self.emptyStarImage
        self.star4ImageView.image = self.emptyStarImage
        self.star5ImageView.image = self.emptyStarImage
        if self.task != nil {
            self.task!(1)
        }
    }
    
    func star2ButtonPressed() {
        print("star-2-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.emptyStarImage
        self.star4ImageView.image = self.emptyStarImage
        self.star5ImageView.image = self.emptyStarImage
        if self.task != nil {
            self.task!(2)
        }
    }
    
    func star3ButtonPressed() {
        print("star-3-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.filledStarImage
        self.star4ImageView.image = self.emptyStarImage
        self.star5ImageView.image = self.emptyStarImage
        if self.task != nil {
            self.task!(3)
        }
    }
    
    func star4ButtonPressed() {
        print("star-4-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.filledStarImage
        self.star4ImageView.image = self.filledStarImage
        self.star5ImageView.image = self.emptyStarImage
        if self.task != nil {
            self.task!(4)
        }
    }
    
    func star5ButtonPressed() {
        print("star-5-ButtonPressed.")
        self.star1ImageView.image = self.filledStarImage
        self.star2ImageView.image = self.filledStarImage
        self.star3ImageView.image = self.filledStarImage
        self.star4ImageView.image = self.filledStarImage
        self.star5ImageView.image = self.filledStarImage
        if self.task != nil {
            self.task!(5)
        }
    }
}
