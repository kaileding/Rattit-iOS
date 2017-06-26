//
//  CapturedPhotoView.swift
//  Rattit
//
//  Created by DINGKaile on 6/25/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class CapturedPhotoView: UIView {
    
    @IBOutlet weak var capturedPhotoImageView: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var cancelButtonLeadingConstraint: NSLayoutConstraint? = nil
    var confirmButtonLeadingConstraint: NSLayoutConstraint? = nil
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static func instantiateFromXib() -> CapturedPhotoView {
        let capturedPhotoView = Bundle.main.loadNibNamed("CapturedPhotoView", owner: self, options: nil)?.first as! CapturedPhotoView
        
        capturedPhotoView.translatesAutoresizingMaskIntoConstraints = false
        capturedPhotoView.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        capturedPhotoView.confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        capturedPhotoView.capturedPhotoImageView.clipsToBounds = true
        capturedPhotoView.capturedPhotoImageView.contentMode = .scaleAspectFill
        
        capturedPhotoView.cancelButton.addTarget(capturedPhotoView, action: #selector(cancelButtonPressed), for: .touchUpInside)
        capturedPhotoView.confirmButton.addTarget(capturedPhotoView, action: #selector(confirmButtonPressed), for: .touchUpInside)
        
        capturedPhotoView.cancelButton.setImage(UIImage(named: "crossMark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        capturedPhotoView.cancelButton.tintColor = UIColor.white
        capturedPhotoView.confirmButton.setImage(UIImage(named: "checkMark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        capturedPhotoView.confirmButton.tintColor = UIColor.white
        
        return capturedPhotoView
    }
    
    func initializeContent(image: UIImage) {
        self.capturedPhotoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        self.capturedPhotoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        self.capturedPhotoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        self.capturedPhotoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        
        self.capturedPhotoImageView.image = image
        self.capturedPhotoImageView.clipsToBounds = true
        self.capturedPhotoImageView.contentMode = .scaleAspectFill
        
        let totalWidth = self.frame.width
        print("in initializeContent() func, the self.frame is ", self.frame.debugDescription, ". totalWidth is ", totalWidth, ". capturedPhotoImageView.frame is ", self.capturedPhotoImageView.frame.debugDescription)
        self.cancelButton.frame = CGRect(x: -40.0, y: (totalWidth-55.0), width: 35.0, height: 35.0)
        self.confirmButton.frame = CGRect(x: -40.0, y: (totalWidth-55.0), width: 35.0, height: 35.0)
        let cancelButtonLeadingSpace = 0.5*totalWidth - 45.0
        let confirmButtonLeadingSpace = 0.5*totalWidth + 10.0
        
        UIView.animate(withDuration: 0.7, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 2.0, options: [.curveEaseIn], animations: {
            
            self.cancelButton.frame = CGRect(x: cancelButtonLeadingSpace, y: (totalWidth-55.0), width: 35.0, height: 35.0)
            self.confirmButton.frame = CGRect(x: confirmButtonLeadingSpace, y: (totalWidth-55.0), width: 35.0, height: 35.0)
            
        }, completion: {(success) in
            print("animation \(success)")
        })
    }
    
    func cancelButtonPressed() {
        print("cancelButtonPressed func.")
        self.removeFromSuperview()
    }
    
    func confirmButtonPressed() {
        print("confirmButtonPressed func.")
        self.removeFromSuperview()
    }
    

}
