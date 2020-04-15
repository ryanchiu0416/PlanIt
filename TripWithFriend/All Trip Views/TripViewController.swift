//
//  TripViewController.swift
//  DailyCalendar
//
//  Created by Ryan Chiu on 2020/3/15.
//  Copyright © 2020 Ryan Chiu. All rights reserved.
//

import UIKit
import Firebase


var tripManager: TripManager? = nil


protocol ToCalendarDelegate {
    func passTrip(selectedTrip: Trip)
}



class TripViewController: UIViewController {
    @IBOutlet weak var TripCollectionView: UICollectionView!
    
    
    var allMyTrips: [Trip] = [Trip]()
    var selectedTrip: Trip?
    var delegate: ToCalendarDelegate?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        allMyTrips = [Trip]()
        
        var myTripIDs = [String]()
        db.collection("Users").document(userEmail!).getDocument { (doc, error) in
            if error == nil {
                if doc != nil && doc!.exists {
                    myTripIDs = doc?.get("MyTrips") as! [String]
                    print(myTripIDs)
                    self.getTripData(tripIDs: myTripIDs) { (true) in
                        print("creating object...")
                        
                        tripManager = TripManager(allMyTrips: self.allMyTrips)
                        DispatchQueue.main.async {
                            self.TripCollectionView.reloadData()
                        }
                    }
                    
                }
            }
        }
    }
    
    func getTripData(tripIDs: [String], completion: @escaping (Bool) -> ()) {
        if tripIDs.count == 0 {
            return
        }
        for i in 0...tripIDs.count - 1 {
            let id = tripIDs[i]
            db.collection("AllTrips").document(id).getDocument { (doc, error) in
                if error == nil {
                    if doc != nil && doc!.exists {
                        let tripName: String = doc!.get("TripName")! as! String
                        let startDate: String = doc!.get("StartDate")! as! String
                        let endDate: String = doc!.get("EndDate")! as! String
                        let people: [String] = doc!.get("People")! as! [String]
                        let imageString: String = doc!.get("ImageString") as! String
                        
                        self.allMyTrips.append(Trip(tripID: id, tripName: tripName, startDate: startDate, endDate: endDate, people: people, imageString: imageString))
                        
                        if self.allMyTrips.count == tripIDs.count {
                            completion(true)
                            print("out of for loop...")
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    @IBAction func addNewTripButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier: "AddNewTripSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCalendar" {
            let vc = segue.destination as? CalendarViewController
            self.delegate = vc
        }
    }
    
    @IBAction func removeTripButtonClick(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to remove this trip?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            let indexToRemove = (sender as AnyObject).tag!
            tripManager!.removeTrip(indexToRemove: indexToRemove)
            DispatchQueue.main.async {
                self.TripCollectionView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}

extension TripViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tripManager == nil || tripManager?.allTrips == nil {
            return 0
        }
        return tripManager!.allTrips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripInfoCell", for: indexPath) as! TripInfoCollectionViewCell
        
        let trip = tripManager!.allTrips[indexPath.row]
        let startDate = NSAttributedString(string: "\(trip.startDate)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        let endDate = NSAttributedString(string: "- \(trip.endDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        
        cell.StartDateLabel.attributedText = startDate
        cell.EndDateLabel.attributedText = endDate
        
        if trip.people.count > 0 {
            var allNames = ""
            for name in trip.people {
                allNames += ", \(name)"
            }
            allNames = String(allNames.dropFirst(2))
            cell.PeopleNameLabel.text = allNames
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 1.0
        
        cell.backgroundImage.image = UIImage(named: trip.imageString)
        
        cell.TripNameNavTitle.title = trip.tripName
        
        cell.removeTripButton.tag = indexPath.row
        cell.removeTripButton.target = self
        cell.removeTripButton.action = #selector(removeTripButtonClick)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TripCollectionView.deselectItem(at: indexPath, animated: true)
        selectedTrip = tripManager!.allTrips[indexPath.row]
        
        self.performSegue(withIdentifier: "ToCalendar", sender: self)
        
        if let delegate = delegate {
            delegate.passTrip(selectedTrip: selectedTrip!)
        }
    }
}
