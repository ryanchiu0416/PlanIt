//
//  TripManager.swift
//  TripWithFriend
//
//  Created by Ryan Chiu on 2020/3/22.
//  Copyright © 2020 Ryan Chiu. All rights reserved.
//

import UIKit

class TripManager: NSObject {
    var allTrips: [Trip]
    
    override init() {
        self.allTrips = [Trip]()
    }
    
    func addTrip(newTrip: Trip) {
        self.allTrips.append(newTrip)
    }
}
