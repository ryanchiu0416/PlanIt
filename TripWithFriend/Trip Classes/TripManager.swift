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
    
    init (allMyTrips: [Trip]) {
        self.allTrips = allMyTrips
    }
    
    func removeTrip(indexToRemove: Int) {
        allTrips.remove(at: indexToRemove)
    }
}
