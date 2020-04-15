//
//  ExpandableTBCell.swift
//  TripWithFriend
//
//  Created by Ryan Chiu on 2020/3/23.
//  Copyright © 2020 Ryan Chiu. All rights reserved.
//

import UIKit

class ExpandableTBCell: UITableViewCell {
    @IBOutlet weak var FirstView: UIView!
    
    @IBOutlet weak var PlaceNameLabel: UILabel!
    @IBOutlet weak var StartTimeLabel: UILabel!
    @IBOutlet weak var EndTimeLabel: UILabel!
    
    @IBOutlet weak var SecondView: UIView!
    @IBOutlet weak var SecondViewLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var fullName: String = ""
    var shownName: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var showDetails = false {
        didSet {
            heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(showDetails ? 250 : 999))
        }
    }
}
