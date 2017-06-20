//
//  BarGraphViewController.swift
//  WaterYouDrinking
//
//  Created by Noah Sutter on 4/23/17.
//  Copyright © 2017 Noah Sutter. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase

class BarGraphViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var barChartView: BarChartView!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var months: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var unitsSold: [Double]!

    @IBOutlet weak var addressPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var typePicker: UIPickerView!
  
    
    var addressPickerData:[String] = ["BOTTLED", "WELL", "STREAM", "LAKE", "SPRING", "OTHER"]
    var addressPickerCurrent: String = ""
    var newPickerData:[String] = []
    
    var datePickerData:[String] = ["2017", "2016"]
    var datePickerCurrent: String = "2017"
    
    var typePickerData:[String] = ["Virus", "Contaminant"]
    var typePickerCurrent: String = "Virus"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        axisFormatDelegate = self
  
        unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        
        
        let ref = FIRDatabase.database().reference()
        ref.child("waterPurityReports").observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            
            while let rest = enumerator.nextObject() {
                let address = (rest as! FIRDataSnapshot).childSnapshot(forPath: "addressString").value as! String
                var first = true
                if (!(self.newPickerData.contains(address))) {
                    if (first) {
                        self.addressPickerCurrent = address
                        first = false
                    }
                    self.newPickerData.append(address)
                }
            }
            self.addressPickerData = self.newPickerData
            self.addressPicker.reloadAllComponents()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        self.addressPicker.dataSource = self
        self.addressPicker.delegate = self
        
        datePicker.dataSource = self
        datePicker.delegate = self
        
        typePicker.dataSource = self
        typePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // DataSource
    //The number of colums of data in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //The number of rows of data in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            return self.addressPickerData.count
        } else if (pickerView.tag == 1) {
            return self.datePickerData.count
        } else {
            return self.typePickerData.count
        }
    }
    
    // Delegate
    //The data to return for the row and component (column) that is being passed in
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return self.addressPickerData[row]
        } else if (pickerView.tag == 1) {
            return self.datePickerData[row]
        } else {
            return self.typePickerData[row]
        }
        
    }
    //Capture the picker selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //This method is triggered whenver the user makes a change to the picker selecton
        //The parameter named row and component represents what was selected
        if (pickerView.tag == 0) {
            self.addressPickerCurrent = addressPickerData[row]
        } else if (pickerView.tag == 1) {
            self.datePickerCurrent = datePickerData[row]
        } else {
            self.typePickerCurrent = typePickerData[row]
        }
        
        
    }
    
    @IBAction func viewAction(_ sender: Any) {
        setChart(dataPoints: self.months, values: self.unitsSold as! [Double])
    }
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        var virusEntries: [BarChartDataEntry] = []
        var contEntries: [BarChartDataEntry] = []
        
        var monthsVirus: [Int] = []
        var monthsContaminant: [Int] = []
        var reportsPerMonth: [Int] = []
        for i in 0...11{
            reportsPerMonth.append(0)
            monthsVirus.append(0)
            monthsContaminant.append(0)
        }

        let selectedYear = Int(datePickerCurrent);
        
        // Specify start date components
        var dateComponents = DateComponents()
        dateComponents.year = selectedYear
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.timeZone = TimeZone(abbreviation: "EST") // Japan Standard Time
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        // Create start date from components
        let userCalendar = Calendar.current // user calendar
        let startDateTime = userCalendar.date(from: dateComponents)
        
        // Specify end date components
        var dateComponents2 = DateComponents()
        dateComponents2.year = selectedYear
        dateComponents2.month = 12
        dateComponents2.day = 31
        dateComponents2.timeZone = TimeZone(abbreviation: "EST") // Japan Standard Time
        dateComponents2.hour = 0
        dateComponents2.minute = 0
        
        // Create end date from components
        let endDateTime = userCalendar.date(from: dateComponents2)
        
        
        
        
        
        
        
        let ref = FIRDatabase.database().reference()
        ref.child("waterPurityReports").observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            
            while let rest = enumerator.nextObject() {
                let time = (rest as! FIRDataSnapshot).childSnapshot(forPath: "timestamp").value as! Int
                let virus = (rest as! FIRDataSnapshot).childSnapshot(forPath: "virusPPM").value
                let contaminant = (rest as! FIRDataSnapshot).childSnapshot(forPath: "contaminantPPM").value
                let address = (rest as! FIRDataSnapshot).childSnapshot(forPath: "addressString").value as! String
                if (address == self.addressPickerCurrent) {
                    let curDate = Date(timeIntervalSince1970: TimeInterval(time/1000))

                    if (curDate >= startDateTime! && curDate <= endDateTime!) {
                        let month = userCalendar.component(.month, from: curDate)
                        monthsVirus[month-1] += virus as! Int
                        monthsContaminant[month-1] += contaminant as! Int
                        reportsPerMonth[month-1] += 1
                    }
                }
            }
            
            for i in 0...reportsPerMonth.count-1 {
                if (reportsPerMonth[i] != 0) {
                    let avgVirus = monthsVirus[i]/reportsPerMonth[i]
                    let avgCont = monthsContaminant[i]/reportsPerMonth[i]
                    virusEntries.append(BarChartDataEntry(x: Double(i), y: Double(avgVirus)))
                    contEntries.append(BarChartDataEntry(x: Double(i), y: Double(avgCont)))
                } else {
                    virusEntries.append(BarChartDataEntry(x: Double(i), y: Double(0)))
                    contEntries.append(BarChartDataEntry(x: Double(i), y: Double(0)))
                }
            }
            var chartDataSet = BarChartDataSet(values: contEntries, label: "Contaminant PPM")
            self.barChartView.chartDescription?.text = "Contaminant PPM by Month"
            if (self.typePickerCurrent == "Virus") {
                chartDataSet = BarChartDataSet(values: virusEntries, label: "Virus PPM")
                self.barChartView.chartDescription?.text = "Virus PPM by Month"
            }
            let chartData = BarChartData(dataSet: chartDataSet)
            self.barChartView.data = chartData
            
            let xaxis = self.barChartView.xAxis
            xaxis.valueFormatter = self.axisFormatDelegate


        }) { (error) in
            print(error.localizedDescription)
        }
        

        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 4.0)
    }

}

// MARK: axisFormatDelegate
extension BarGraphViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
}


