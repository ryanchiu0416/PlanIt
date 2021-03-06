//
//  TripInfoCollectionViewCell.swift
//  DailyCalendar
//
//  Created by Ryan Chiu on 2020/3/15.
//  Copyright © 2020 Ryan Chiu. All rights reserved.
//

import UIKit


// Used in TripViewController
class TripInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var StartDateLabel: UILabel!
    @IBOutlet weak var EndDateLabel: UILabel!
    @IBOutlet weak var PeopleNameLabel: UILabel!
    @IBOutlet weak var TripNameNavTitle: UINavigationItem!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var removeTripButton: UIBarButtonItem!
    
}
