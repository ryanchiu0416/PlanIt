//
//  EventDetail.swift
//  DailyCalendar
//
//  Created by Ryan Chiu on 2020/3/15.
//  Copyright © 2020 Ryan Chiu. All rights reserved.
//

import UIKit

class EventDetail: NSObject {
    var eventID: String
    var placeName: String
    var date: String
    var startTime: String
    var endTime: String
    var notes: String
    var startTimeDateObj: Date
    
    init(placeName: String, date: String, startTime: String, endTime: String, notes: String, eventID: String) {
        self.date = date
        self.placeName = placeName
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
        self.eventID = eventID
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        self.startTimeDateObj = timeFormatter.date(from: startTime)!
    }
}
