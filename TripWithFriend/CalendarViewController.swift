//
//  ViewController.swift
//  DailyCalendar
//
//  Created by Ryan Chiu on 2020/2/9.
//  Copyright © 2020 Ryan Chiu. All rights reserved.
//

import UIKit
let dayOfWeeks: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]




let allPlans: [[[String]]] = [   [["2020-03-23"], ["Seattle, WA", "9:00", "11:00"], ["Los Angeles", "13:00", "16:00"]],
                              [["2020-03-24"], ["Hub U District", "12:00", "13:00"], ["Bay Area", "15:00", "16:00"]] ]
var planIndex = 0;

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    lazy var dailyPlans = allPlans[planIndex]
    
    @IBAction func clickPreviousButton(_ sender: Any) {
        if (planIndex - 1 >= 0) {
            planIndex -= 1
            print(planIndex)
            dailyPlans = allPlans[planIndex]
            resetDayLabel(date: dailyPlans[0][0])
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
            checkArrowButtons()
        }
    }
    
    @IBAction func clickNextButton(_ sender: Any) {
        if (planIndex + 1 <= allPlans.count - 1) {
            planIndex += 1
            print(planIndex)
            dailyPlans = allPlans[planIndex]
            resetDayLabel(date: dailyPlans[0][0])
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
            checkArrowButtons()
        }
    }
    
    @IBOutlet weak var calendarView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetDayLabel(date: dailyPlans[0][0])
        
        checkArrowButtons()
        
//        print(trip1.tripName)
//        print(trip1.allDates)
//        for day in trip1.dailyEvents.keys {
//            for event in trip1.dailyEvents[day]! {
//                print(event.placeName)
//                print(event.date)
//                print(event.startTime)
//                print(event.endTime)
//            }
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyPlans.count - 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCollectionViewCell
        let plan = dailyPlans[indexPath.row + 1]
        cell.itemLabel.text = plan[0]
        let start = NSAttributedString(string: "\(plan[1])", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        let end = NSAttributedString(string: "- \(plan[2])", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        cell.startLabel.attributedText = start
        cell.endLabel.attributedText = end
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 1.0
        
        return cell
    }
    
    func resetDayLabel(date:String) {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "MM/dd/yyyy"
        let resultDate = inputFormatter.string(from: showDate!)
        var dayOfWeek = ""
        
        if let weekday = getDayOfWeek(dailyPlans[0][0]) {
            dayOfWeek = dayOfWeeks[weekday]
        } else {
            print("bad input")
        }
        dateLabel.text = "\(resultDate) - \(dayOfWeek)"
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay - 1
    }
    
    func checkArrowButtons() {
        if planIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
        
        if planIndex == allPlans.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
}




