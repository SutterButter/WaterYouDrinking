//
//  EditProfileViewController.swift
//  WaterYouDrinking
//
//  Created by Noah Sutter on 4/20/17.
//  Copyright © 2017 Noah Sutter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EditProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
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
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            self.ref = FIRDatabase.database().reference()
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let email = value?["email"] as? String ?? ""
                self.emailField.text = email
                let address = value?["userAddress"] as? String ?? ""
                self.addressField.text = address
                self.userType = value?["userType"] as? String ?? ""
                self.userPicker.selectRow(self.findPickerRow(usertype: self.userType), inComponent: 0, animated: true)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    func findPickerRow(usertype: String) -> Int {
        switch(usertype) {
        case "USER":
            return 0
        case "WORKER" :
            return 1
        case "MANAGER" :
            return 2
        case "ADMIN" :
            return 3
        default :
            return 0
        }
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
    

    @IBAction func submitChangesAction(_ sender: Any) {
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            self.ref = FIRDatabase.database().reference()

            
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                
                if self.emailField.text != "" {
                    FIRAuth.auth()?.currentUser?.updateEmail(self.emailField.text!, completion: { (error) in
                        if error != nil {
                            let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            print("email failed")
                        } else {
                            var address = ""
                            if self.addressField.text! != "" {
                                address = self.addressField.text!
                            } else {
                                address = value?["address"] as? String ?? ""
                            }
                            self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(["email": self.emailField.text!, "userAddress": address, "userType": self.userType])
                            print("email")
                        }
                    })
                } else {
                    var address = ""
                    if self.addressField.text! != "" {
                        address = self.addressField.text!
                    } else {
                        address = value?["address"] as? String ?? ""
                    }
                    let email = value?["address"] as? String ?? ""
                    self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(["email": email, "userAddress": address, "userType": self.userType])
                    print("email")
                }
                
                if self.newPasswordField.text != "" {
                    FIRAuth.auth()?.currentUser?.updatePassword(self.newPasswordField.text!, completion: { (error) in
                        if error != nil {
                            let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
           
        
            self.performSegue(withIdentifier: "editToWelcomeSegue", sender: "self")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    
}
