//
//  SubmitWPRViewController.swift
//  WaterYouDrinking
//
//  Created by Noah Sutter on 4/21/17.
//  Copyright © 2017 Noah Sutter. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
import FirebaseDatabase

class SubmitWPRViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var ref: FIRDatabaseReference!
    
    
    @IBOutlet weak var condPicker: UIPickerView!
    @IBOutlet weak var virusField: UITextField!
    @IBOutlet weak var condField: UITextField!
    
    
    let condPickerData = ["SAFE", "TREATABLE", "UNSAFE"]
    var condPickerCurrent: String = "SAFE"
    
    
    var address = ""
    var location = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 375.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        condPicker.dataSource = self
        condPicker.delegate = self
    }
    
    
    

    @IBAction func submitReportAction(_ sender: Any) {
        
        if self.address != "" && self.virusField.text != "" && self.condField.text != "" {
            let location: NSDictionary = [
                "latitude" : self.location.latitude,
                "longitude": self.location.longitude
            ]
            let newval: NSDictionary = [
                "addressString" : self.address,
                "contaminantPPM" : Int(self.condField.text!),
                "location" : location,
                "name" : FIRAuth.auth()?.currentUser?.email ?? "no name",
                "reportNumber" : 0,
                "timestamp": FIRServerValue.timestamp(),
                "virusPPM" : Int(self.virusField.text!),
                "waterCondition": self.condPickerCurrent
            ]
            self.ref = FIRDatabase.database().reference()
            self.ref.child("waterPurityReports").childByAutoId().setValue(newval)
            self.ref = FIRDatabase.database().reference()
            ref.child("waterPurityReportsLocations").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let num = value?[self.address] as? Int ?? 0
                self.ref.child("waterPurityReportsLocations").child(self.address).setValue(num+1)
            }) { (error) in
                print(error.localizedDescription)
            }
            self.performSegue(withIdentifier: "submitWPRSegue", sender: "self")

            
            
            
            
            
            
        } else {
            let alertController = UIAlertController(title: "Oops", message: "Please enter a place, a virus PPM, and a Contamination PPM.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    // DataSource
    //The number of colums of data in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //The number of rows of data in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return condPickerData.count
    }
    
    // Delegate
    //The data to return for the row and component (column) that is being passed in
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return condPickerData[row]
    }
    //Capture the picker selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //This method is triggered whenver the user makes a change to the picker selecton
        //The parameter named row and component represents what was selected
        condPickerCurrent = condPickerData[row]
    }
}



// Handle the user's selection.
extension SubmitWPRViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        self.address = place.formattedAddress!
        self.location = place.coordinate
        self.locationLabel.text = place.name
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
