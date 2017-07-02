//
//  LocationRatingView.swift
//  Rattit
//
//  Created by DINGKaile on 7/1/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class LocationRatingView: UIView {
    
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
    
    static func instantiateFromXib() -> LocationRatingView {
        let locationRatingView = Bundle.main.loadNibNamed("LocationRatingView", owner: self, options: nil)?.first as! LocationRatingView
        
        locationRatingView.star1ImageView.image = locationRatingView.emptyStarImage
        locationRatingView.star1ImageView.tintColor = UIColor(red: 0, green: 0.5098, blue: 0.7882, alpha: 1.0)
        locationRatingView.star2ImageView.image = locationRatingView.emptyStarImage
        locationRatingView.star2ImageView.tintColor = UIColor(red: 0, green: 0.5098, blue: 0.7882, alpha: 1.0)
        locationRatingView.star3ImageView.image = locationRatingView.emptyStarImage
        locationRatingView.star3ImageView.tintColor = UIColor(red: 0, green: 0.5098, blue: 0.7882, alpha: 1.0)
        locationRatingView.star4ImageView.image = locationRatingView.emptyStarImage
        locationRatingView.star4ImageView.tintColor = UIColor(red: 0, green: 0.5098, blue: 0.7882, alpha: 1.0)
        locationRatingView.star5ImageView.image = locationRatingView.emptyStarImage
        locationRatingView.star5ImageView.tintColor = UIColor(red: 0, green: 0.5098, blue: 0.7882, alpha: 1.0)
        
        locationRatingView.star1Button.addTarget(locationRatingView, action: #selector(star1ButtonPressed), for: .touchDown)
        locationRatingView.star1Button.addTarget(locationRatingView, action: #selector(star1ButtonPressed), for: .touchDragEnter)
        locationRatingView.star2Button.addTarget(locationRatingView, action: #selector(star2ButtonPressed), for: .touchDown)
        locationRatingView.star2Button.addTarget(locationRatingView, action: #selector(star2ButtonPressed), for: .touchDragEnter)
        locationRatingView.star3Button.addTarget(locationRatingView, action: #selector(star3ButtonPressed), for: .touchDown)
        locationRatingView.star3Button.addTarget(locationRatingView, action: #selector(star3ButtonPressed), for: .touchDragEnter)
        locationRatingView.star4Button.addTarget(locationRatingView, action: #selector(star4ButtonPressed), for: .touchDown)
        locationRatingView.star4Button.addTarget(locationRatingView, action: #selector(star4ButtonPressed), for: .touchDragEnter)
        locationRatingView.star5Button.addTarget(locationRatingView, action: #selector(star5ButtonPressed), for: .touchDown)
        locationRatingView.star5Button.addTarget(locationRatingView, action: #selector(star5ButtonPressed), for: .touchDragEnter)
        
        return locationRatingView
    }
    
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
