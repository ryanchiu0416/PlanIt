//
//  Trip.swift
//  DailyCalendar
//
//  Created by Ryan Chiu on 2020/3/15.
//  Copyright © 2020 Ryan Chiu. All rights reserved.
//

import UIKit

class Trip: NSObject {
    var tripID: String
    var tripName: String
    var startDate: String
    var endDate: String
    var dailyEvents: [String : [EventDetail]]
    var people: [String]
    var imageString: String
    
    init(tripID: String, tripName: String, startDate: String, endDate: String, people: [String], imageString: String) {
        self.tripName = tripName
        self.startDate = startDate
        self.endDate = endDate
        self.dailyEvents = [String : [EventDetail]]()
        self.people = people
        self.imageString = imageString
        self.tripID = tripID
    }
    
    func resetCalendarEvents() {
        for date in dailyEvents.keys {
            dailyEvents[date] = [EventDetail]()
        }
    }
}
