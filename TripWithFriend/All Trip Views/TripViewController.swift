//
//  TripViewController.swift
//  DailyCalendar
//
//  Created by Ryan Chiu on 2020/3/15.
//  Copyright © 2020 Ryan Chiu. All rights reserved.
//

import UIKit

let event1 = EventDetail(placeName: "Seattle, WA", date: "2020-03-23", startTime: "9:00", endTime: "11:00")
let event2 = EventDetail(placeName: "Los Angeles", date: "2020-03-23", startTime: "13:00", endTime: "16:00")
let event3 = EventDetail(placeName: "Hub U District", date: "2020-03-24", startTime: "12:00", endTime: "13:00")
let event4 = EventDetail(placeName: "Bay Area", date: "2020-03-24", startTime: "15:00", endTime: "16:00")

let trip1 = Trip(tripName: "RoadTrip", startDate: "2020-03-23", endDate: "2020-03-24", allEvents: [event1, event2, event3, event4], people: ["Ryan (Me)"])

var tripManager: TripManager = TripManager()
var userName = "Ryan (Me)"


protocol ToCalendarDelegate {
    func passTrip(selectedTrip: Trip)
}



class TripViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var TripCollectionView: UICollectionView!
    
    
    var selectedTrip: Trip?
    var delegate: ToCalendarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func addNewTripButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier: "AddNewTripSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewTripSegue" {
            let vc = segue.destination as? AddTripViewController
            vc?.delegate = self
        } else if segue.identifier == "ToCalendar" {
            let vc = segue.destination as? CalendarViewController
            self.delegate = vc
            print("after delegate")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tripManager.allTrips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripInfoCell", for: indexPath) as! TripInfoCollectionViewCell
        
        let trip = tripManager.allTrips[indexPath.row]
        cell.TripNameLabel.text = trip.tripName
        let startDate = NSAttributedString(string: "\(trip.startDate)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        let endDate = NSAttributedString(string: "- \(trip.endDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        
        cell.StartDateLabel.attributedText = startDate
        cell.EndDateLabel.attributedText = endDate
        
        if trip.people.count > 0 {
            var allNames = ""
            for name in trip.people {
                allNames += ", \(name)"
            }
            print(allNames)
            allNames = String(allNames.dropFirst(2))
            print(allNames)
            cell.PeopleNameLabel.text = allNames
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 1.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TripCollectionView.deselectItem(at: indexPath, animated: true)
        selectedTrip = tripManager.allTrips[indexPath.row]
        
        self.performSegue(withIdentifier: "ToCalendar", sender: self)
        
        if let delegate = delegate {
            print("pass in from didSelectItemAt")
            delegate.passTrip(selectedTrip: selectedTrip!)
        }
    }
    

}

extension TripViewController: NewTripDelegate {
    func addNewTrip(placeName: String, startDate: String, endDate: String, people: Set<String>) {
        tripManager.addTrip(newTrip: Trip(tripName: placeName, startDate: startDate, endDate: endDate, allEvents: [], people: people))
        
        DispatchQueue.main.async {
            self.TripCollectionView.reloadData()
        }
    }
}
