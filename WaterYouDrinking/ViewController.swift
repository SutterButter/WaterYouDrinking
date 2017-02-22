//
//  ViewController.swift
//  WaterYouDrinking
//
//  Created by Noah Sutter on 2/20/17.
//  Copyright © 2017 Noah Sutter. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var ClassPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = FIRAuth.auth()?.currentUser {
            self.logoutButton.alpha = 1.0
            self.usernameLabel.text = user.email
        } else {
            self.logoutButton.alpha = 0.0
            self.usernameLabel.text = ""
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func createAccountAction(_ sender: Any) {
        if self.emailField.text == "" || self.passwordField.text == "" {
            
            let alertController = UIAlertController(title: "Oops", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                
                if error == nil {
                    
                    self.logoutButton.alpha = 1.0
                    self.usernameLabel.text = user!.email
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.performSegue(withIdentifier: "LoginSegue", sender: "self")
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
        }
    }

    @IBAction func loginAction(_ sender: Any) {
        if self.emailField.text == "" || self.passwordField.text == "" {
            
            let alertController = UIAlertController(title: "Oops", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                
                if error == nil {
                    
                    self.logoutButton.alpha = 1.0
                    self.usernameLabel.text = user!.email
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.performSegue(withIdentifier: "LoginSegue", sender: "self")
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            })
        }

    }
    @IBAction func logoutAction(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        
        self.usernameLabel.text = ""
        self.logoutButton.alpha = 0.0
        self.emailField.text = ""
        self.passwordField.text = ""
    }
}

