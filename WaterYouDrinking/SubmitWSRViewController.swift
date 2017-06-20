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

class SubmitWSRViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var ref: FIRDatabaseReference!
    
    
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var condPicker: UIPickerView!
    
    let typePickerData = ["BOTTLED", "WELL", "STREAM", "LAKE", "SPRING", "OTHER"]
    var typePickerCurrent: String = "BOTTLED"
    
    let condPickerData = ["WASTE", "TREATABLE-CLEAR", "TREATABLE-MUDDY", "POTABLE"]
    var condPickerCurrent: String = "WASTE"
    
    
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
        
        typePicker.dataSource = self
        typePicker.delegate = self
        
        condPicker.dataSource = self
        condPicker.delegate = self
    }
    

    
    @IBAction func submitReportAction(_ sender: Any) {
     
        if self.address != "" {
            let location: NSDictionary = [
                "latitude" : self.location.latitude,
                "longitude": self.location.longitude
            ]
            let newval: NSDictionary = [
                "addressString" : self.address,
                "location" : location,
                "name" : FIRAuth.auth()?.currentUser?.email ?? "no name",
                "reportNumber" : 0,
                "timestamp": FIRServerValue.timestamp(),
                "waterCondition": self.condPickerCurrent,
                "waterType": self.typePickerCurrent
            ]
            self.ref = FIRDatabase.database().reference()
            self.ref.child("waterSourceReports").childByAutoId().setValue(newval)
            self.performSegue(withIdentifier: "submitWSRSegue", sender: "self")
        } else {
            let alertController = UIAlertController(title: "Oops", message: "Please enter a place.", preferredStyle: .alert)
            
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
        if (pickerView.tag == 0) {
            return typePickerData.count
        } else {
            return condPickerData.count
        }
    }
    
    // Delegate
    //The data to return for the row and component (column) that is being passed in
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return typePickerData[row]
        } else {
            return condPickerData[row]
        }
        
    }
    //Capture the picker selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //This method is triggered whenver the user makes a change to the picker selecton
        //The parameter named row and component represents what was selected
        if (pickerView.tag == 0) {
            typePickerCurrent = typePickerData[row]
        } else {
            condPickerCurrent = condPickerData[row]
        }
        
        
    }
}



// Handle the user's selection.
extension SubmitWSRViewController: GMSAutocompleteResultsViewControllerDelegate {
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
