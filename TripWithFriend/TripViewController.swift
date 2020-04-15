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

let trip1 = Trip(tripName: "RoadTrip", startDate: "2020-03-23", endDate: "2020-03-24", allEvents: [], people: [])

var listOfTrip: [Trip] = [Trip]()
var userName = "Ryan (Me)"


class TripViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var TripCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfTrip.append(trip1)
        print(listOfTrip)
    }
    
    
    @IBAction func addNewTripButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier: "AddNewTripSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewTripSegue" {
            let vc = segue.destination as? AddTripViewController
            vc?.delegate = self
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfTrip.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripInfoCell", for: indexPath) as! TripInfoCollectionViewCell
        
        let trip = listOfTrip[indexPath.row]
        cell.TripNameLabel.text = trip.tripName
        let startDate = NSAttributedString(string: "\(trip.startDate)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        let endDate = NSAttributedString(string: "- \(trip.endDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        
        cell.StartDateLabel.attributedText = startDate
        cell.EndDateLabel.attributedText = endDate
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 1.0
        
        return cell
    }
    

}

extension TripViewController: NewTripDelegate {
    func addNewTrip(placeName: String, startDate: String, endDate: String, people: [String]) {
        
        print(people)
        listOfTrip.append(Trip(tripName: placeName, startDate: startDate, endDate: endDate, allEvents: [], people: people))
        
        DispatchQueue.main.async {
            self.TripCollectionView.reloadData()
        }
        print(listOfTrip)
        
        for trip in listOfTrip {
            print(trip.tripName)
            print(trip.people)
        }
    }
    
    
}
