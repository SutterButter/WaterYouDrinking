//
//  CreateAccountViewController.swift
//  WaterYouDrinking
//
//  Created by Noah Sutter on 2/20/17.
//  Copyright © 2017 Noah Sutter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CreateAccountViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var userPicker: UIPickerView!
    
    
    let pickerData = ["USER", "WORKER", "MANAGER", "ADMIN"]
    var ref: FIRDatabaseReference!
    var userType: String = "USER"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //connect data
        userPicker.dataSource = self
        userPicker.delegate = self
        
        
    }
    
    
    
    
    // DataSource
    //The number of colums of data in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //The number of rows of data in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Delegate
    //The data to return for the row and component (column) that is being passed in
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    //Capture the picker selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //This method is triggered whenver the user makes a change to the picker selecton
        //The parameter named row and component represents what was selected
        userType = pickerData[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    

    @IBAction func createAccountAction(_ sender: Any) {
        if self.emailField.text == "" || self.passwordField.text == "" || self.addressField.text == "" {
            
            let alertController = UIAlertController(title: "Oops", message: "Please enter an email, a password, and an address.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                if error == nil {
                    self.ref = FIRDatabase.database().reference()
                    self.ref.child("users").child(user!.uid).setValue(["email": self.emailField.text!, "userAddress": self.addressField.text!, "userType": self.userType])
                    self.performSegue(withIdentifier: "createAccountLoginSegue", sender: "self")
                } else {
                    let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    
}

