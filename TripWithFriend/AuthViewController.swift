//
//  AuthViewController.swift
//  TripWithFriend
//
//  Created by Ryan Chiu on 2020/3/26.
//  Copyright © 2020 Ryan Chiu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


// User Record
var userName: String? = nil
var userEmail: String? = nil

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    var isSignIn = true
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElement()
        firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
    }
    
    @IBAction func signInSwitched(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        if isSignIn {
            signInButton.setTitle("Sign In", for: .normal)
            firstNameTextField.isHidden = true
            lastNameTextField.isHidden = true
        } else {
            signInButton.setTitle("Sign Up", for: .normal)
            firstNameTextField.isHidden = false
            lastNameTextField.isHidden = false
        }
    }
    
    
    // For SIGN IN: when user signs in, fetch all trips data to display in the next screen. (Fetch in closure)
    
    @IBAction func signInButtonClick(_ sender: UIButton) {
        print("Button Clicked")
        
        let str = validateFields()
        if str != nil {
            showWarningAlert(errorMsg: str!)
            return
        }
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            if isSignIn {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    if user != nil {
                    // user is found
                        // retain user email and find user's first name & last name
                        self.db.collection("Users").document(email).getDocument { (document, error) in
                            if error == nil {
                                if document != nil && document!.exists {
                                    let data = document?.data()
                                    userName = "\(data!["FirstName"]!) \(data!["LastName"]!)"
                                    userEmail = email
                                    self.performSegue(withIdentifier: "ToHomeScreen", sender: self)
                                }
                            }
                        }
                        
                        // proceed to home screen
//                        self.performSegue(withIdentifier: "ToHomeScreen", sender: self)
                    } else {
                    // error
                        self.showWarningAlert(errorMsg: error!.localizedDescription)
                    }
                }
            } else {
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    if user != nil {
                    // user sign up success
                        // store user's first name and last name with corresponding email
                        let userAccount = self.db.collection("Users").document(email)
                        userAccount.setData(["FirstName": self.firstNameTextField.text!, "LastName": self.lastNameTextField.text!, "MyTrips": []])
                        userEmail = email
                        userName = "\(self.firstNameTextField.text!) \(self.lastNameTextField.text!)"
                        
                        // proceed to home screen
                        self.performSegue(withIdentifier: "ToHomeScreen", sender: self)
                    } else {
                    // error
                        self.showWarningAlert(errorMsg: error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    func showWarningAlert(errorMsg: String) {
        let alert = UIAlertController(title: "Error Occurred", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func validateFields() -> String? {
        if isSignIn && (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            return "Please Type in Email and Password"
        }
        
        if !isSignIn && (firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            return "Please Fill in all Fields"
        }
        
        return nil
    }
    
    func setupElement() {
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signInButton)
    }
}
