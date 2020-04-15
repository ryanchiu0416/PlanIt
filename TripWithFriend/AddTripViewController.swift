//
//  AddTripViewController.swift
//  DailyCalendar
//
//  Created by Ryan Chiu on 2020/3/15.
//  Copyright © 2020 Ryan Chiu. All rights reserved.
//

import UIKit

protocol NewTripDelegate {
    func addNewTrip(placeName: String, startDate: String, endDate: String, people: [String])
}

class AddTripViewController: UIViewController {
    @IBOutlet weak var TripNameTextField: UITextField!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    @IBOutlet weak var addFriendTextField: UITextField!
    @IBOutlet weak var nameEnterButton: UIButton!
    
    var delegate: NewTripDelegate?
    
    var activeTextField = UITextField()
    var selectedStartDate: String = ""
    var selectedEndDate: String = ""
    var friendsList: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TripNameTextField.delegate = self
        addFriendTextField.delegate = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: Date())
        selectedStartDate = selectedDate
        selectedEndDate = selectedDate
        friendsList.append(userName)
        
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        // listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
    }
    
    deinit {
        // stop listening for keyboardevents
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @IBAction func clickSaveButton(_ sender: Any) {
        if let delegate = delegate {
            delegate.addNewTrip(placeName: TripNameTextField.text!, startDate: selectedStartDate, endDate: selectedEndDate, people: friendsList)
        }
        clickCancelButton(self)
    }
    
    @IBAction func clickCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startDateChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: StartDatePicker.date)
        selectedStartDate = selectedDate
        print(selectedDate)
    }
    
    @IBAction func endDateChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: EndDatePicker.date)
        selectedEndDate = selectedDate
        print(selectedDate)
    }
    
    @IBAction func addFriendsButtonClicked(_ sender: Any) {
        addFriendTextField.isHidden = false
        nameEnterButton.isHidden = false
        
    }
    
    @IBAction func enterFriendsNameButtonClick(_ sender: Any) {
        if !friendsList.contains(addFriendTextField.text!) && !addFriendTextField.text!.isEmpty {
            friendsList.append(addFriendTextField.text!)
        }
        
        addFriendTextField.text = "";
        addFriendTextField.isHidden = true
        nameEnterButton.isHidden = true
    }
}

extension AddTripViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let currTextFieldHeight = activeTextField.frame.origin.y
        
        if (notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification) && currTextFieldHeight >= keyboardRect.height {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
}
