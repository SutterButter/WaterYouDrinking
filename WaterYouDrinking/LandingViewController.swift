//
//  LandingViewController.swift
//  WaterYouDrinking
//
//  Created by Noah Sutter on 4/19/17.
//  Copyright © 2017 Noah Sutter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LandingViewController: UIViewController {
   
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var submitWSRButton: UIButton!
    @IBOutlet weak var submitWPRButton: UIButton!
    @IBOutlet weak var viewMapButton: UIButton!
    @IBOutlet weak var viewPurityMapButton: UIButton!
    @IBOutlet weak var viewWSRButton: UIButton!
    @IBOutlet weak var viewWPRButton: UIButton!
    @IBOutlet weak var viewGraphButton: UIButton!
    
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        self.ref = FIRDatabase.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let userType = value?["userType"] as? String ?? ""
            if (userType == "USER") {
                self.submitWPRButton.isHidden = true
                self.viewWPRButton.isHidden = true
                self.viewGraphButton.isHidden = true
                self.viewPurityMapButton.isHidden = true
            } else if (userType == "WORKER") {
                self.viewWPRButton.isHidden = true
                self.viewGraphButton.isHidden = true
                self.viewPurityMapButton.isHidden = true
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        super.viewDidAppear(animated)
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            self.performSegue(withIdentifier: "logOutSegue", sender: "self")
        } catch let signOutError as NSError {
            let alertController = UIAlertController(title: "Oops", message: signOutError.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
}

