//
//  WSRTableViewController.swift
//  WaterYouDrinking
//
//  Created by Noah Sutter on 4/23/17.
//  Copyright © 2017 Noah Sutter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class WSRTableViewController: UITableViewController {

    var WSRs = [NSDictionary]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadSampleMeals()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    private func loadSampleMeals() {
        
        let ref = FIRDatabase.database().reference()
        
        
        let myGroup = DispatchGroup()
        
        
        myGroup.enter()
        ref.child("waterSourceReports").observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var i = 0
            while let rest = enumerator.nextObject() {
                let WSR = [
                    "report": (rest as! FIRDataSnapshot).childSnapshot(forPath: "reportNumber").value,
                    "address": (rest as! FIRDataSnapshot).childSnapshot(forPath: "addressString").value,
                    "condition": (rest as! FIRDataSnapshot).childSnapshot(forPath: "waterCondition").value,
                    "type": (rest as! FIRDataSnapshot).childSnapshot(forPath: "waterType").value
                ]
                self.WSRs.append(WSR as! NSDictionary)
                i+=1
            }
            myGroup.leave()
            print(self.WSRs.count)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.WSRs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WSRTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WSRTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WSRTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let wsr = self.WSRs[indexPath.row]
        
        cell.reportLabel.text = "Report " + String(indexPath.row)
        cell.addressLabel.text = wsr["address"] as? String
        cell.conditionLabel.text = "Water Condition: " + (wsr["condition"] as? String)!
        cell.typeLabel.text = "Water Type: " + (wsr["type"] as? String)!
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
