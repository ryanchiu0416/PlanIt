//
//  EventViewController.swift
//  TripWithFriend
//
//  Created by Ryan Chiu on 2020/3/22.
//  Copyright © 2020 Ryan Chiu. All rights reserved.
//

import UIKit

let autoCompleteBaseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyDz_7dQxAfZqxRxzl2yZHHMWhoU0biHXAM&input="

struct AutoCompleteAPIResult: Codable {
    let predictions: [Result]
    let status: String
    
    struct Result: Codable {
        let description: String
    }
}

protocol SendBackEventDetailDelegate {
    func sendBackNewEvent(placeString: String, startTime: String, endTime: String, notes: String)
}


class EventViewController: UIViewController {
    @IBOutlet weak var EventNameTextField: UITextField!
    @IBOutlet weak var NoteTextView: UITextView!
    @IBOutlet weak var StartTimePicker: UIDatePicker!
    @IBOutlet weak var EndTimePicker: UIDatePicker!
    @IBOutlet weak var ACTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var activeTextField = UITextField()
    var selectedStartTime: String = ""
    var selectedEndTime: String = ""
    var delegate: SendBackEventDetailDelegate?
    
    var autoResults = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElement()
        
        NoteTextView.layer.cornerRadius = 10
        NoteTextView.layer.borderColor = UIColor.lightGray.cgColor
        NoteTextView.layer.borderWidth = 1.0
        
        EventNameTextField.delegate = self
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let currentTime = timeFormatter.string(from: Date())

        // calculate closest possible time in 15 min chunk
        let str = currentTime.components(separatedBy: " ")
        let timeChunk = str[0].components(separatedBy: ":")
        let amPm = str[1]
        let hour = timeChunk[0]
        let minute: Int = Int(timeChunk[1])!
        
        let full15Min = minute / 15
        let remainderMin = minute % 15
        var resultMin: Int = minute
        var resultMinString: String = String(minute)
        if remainderMin != 0 {
            resultMin = full15Min * 15
            if resultMin == 0 {
                resultMinString = "00"
            } else {
                resultMinString = String(resultMin)
            }
            
        }
        let finalStr = "\(hour):\(resultMinString) \(amPm)"
        selectedStartTime = finalStr
        selectedEndTime = finalStr
        
        
        // AutoComplete TableView
        ACTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecommendsCell")
        ACTableView.layer.cornerRadius = 10
        ACTableView.layer.borderColor = UIColor.lightGray.cgColor
        ACTableView.layer.borderWidth = 1.0
        
        
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
    
    
    
    @IBAction func SaveButtonClicked(_ sender: Any) {
        if let delegate = delegate {
            delegate.sendBackNewEvent(placeString: EventNameTextField.text!, startTime: selectedStartTime, endTime: selectedEndTime, notes: NoteTextView.text!)
        }
        cancelButtonClicked(self)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func StartTimeChanged(_ sender: Any) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        EndTimePicker.date = StartTimePicker.date
        selectedStartTime = timeFormatter.string(from: StartTimePicker.date)
        selectedEndTime = selectedStartTime
    }
    
    @IBAction func EndTimeChanged(_ sender: Any) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        selectedEndTime = timeFormatter.string(from: EndTimePicker.date)
    }
    
    @IBAction func EventNameFieldChanged(_ sender: Any) {
        // fetch AC API data
        if EventNameTextField.text!.isEmpty {
            ACTableView.isHidden = true
            return
        }
        
        self.autoResults.removeAll()
        let str = EventNameTextField.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = URL(string: autoCompleteBaseURL + str!)
        
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            guard let data = data else { return }

            do {
                // results is the parsed data
                let results = try JSONDecoder().decode(AutoCompleteAPIResult.self, from: data)
                
                // append rec locations to array
                for i in 0..<results.predictions.count {
                    self.autoResults.append(results.predictions[i].description)
                }
                
                DispatchQueue.main.async {
                    if self.autoResults.count > 0 {
                        self.ACTableView.isHidden = false
                    } else {
                        self.ACTableView.isHidden = true
                    }
                    self.ACTableView.reloadData()
                }
                
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    
    func setupElement() {
        Utilities.styleTextField(EventNameTextField)
        Utilities.styleFilledButton(saveButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        EventNameTextField.resignFirstResponder()
        NoteTextView.resignFirstResponder()
        ACTableView.isHidden = true
        
    }
}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = autoResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendsCell")
        cell?.textLabel?.text = result
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.EventNameTextField.text = self.autoResults[indexPath.row]
        self.ACTableView.isHidden = true
    }
}


extension EventViewController: UITextFieldDelegate {
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
