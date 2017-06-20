//
//  SignInViewController.swift
//  WaterYouDrinking
//
//  Created by Noah Sutter on 2/20/17.
//  Copyright © 2017 Noah Sutter. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    
    let pickerData = ["User", "Worker", "Manager", "Admin"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!


    @IBAction func loginAction(_ sender: Any) {
        if self.emailField.text == "" || self.passwordField.text == "" {
            
            let alertController = UIAlertController(title: "Oops", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                
                if error == nil {
                    //self.usernameLabel.text = user!.email
                    self.performSegue(withIdentifier: "loginSegue", sender: "self")
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

