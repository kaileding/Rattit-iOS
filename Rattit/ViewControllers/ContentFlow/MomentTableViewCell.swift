//
//  MomentTableViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class MomentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var momentWordsLabel: UILabel!
    
    var moment: Moment! {
        didSet {
            self.titleLabel.text = moment.title
            self.momentWordsLabel.text = moment.words
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // UI Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
