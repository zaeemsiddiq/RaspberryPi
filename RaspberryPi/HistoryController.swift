//
//  HistoryController.swift
//  RaspberryPi
//
//  Created by Zaeem Siddiq on 10/9/16.
//  Copyright © 2016 Zaeem Siddiq. All rights reserved.
//

/*
 This controller gets the time histories from the sensors and displays. The controller is dealing with 2 methods, one is getting the time based temperatures and the other is getting lst N values from the sensor.
 */
import UIKit

class HistoryController: UIViewController, ServiceDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var fromDate: UIDatePicker!
    @IBOutlet weak var toDate: UIDatePicker!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var textLastN: UITextField!
    
    var temperatureValues = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    @IBAction func getByDate(sender: AnyObject) {
        let fromDateUtc = fromDate.date.timeIntervalSince1970
        let toDateUtc = toDate.date.timeIntervalSince1970
        print("\(String(fromDateUtc)):\(String(toDateUtc))")
        
        let tempService = HttpRequestService(delegate: self)
        tempService.getTempBydate(String(fromDateUtc), endUtc: String(toDateUtc))
    }
    
    @IBAction func getLastN(sender: AnyObject) {
        var isValid: Bool = true
        let num = Int(textLastN.text!)
        if textLastN.text == "" {
            isValid = false
             generateNotification("Error", message: "Please enter a number")
        } else if num == nil {
            isValid = false
            generateNotification("Error", message: "Please enter a valid number")
        }
        if isValid {
             let tempService = HttpRequestService(delegate: self)
        }
        
    }
    
    // this method generates a notification on.
    func generateNotification(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func didReceiveError(error:String) {
        
    }
    
    // this method gets called from the HTTPRequestService
    func serviceComplete(data: NSData, functionCall: String) {
        if functionCall == HttpRequestService.GET_TEMP_N {
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                    // parsing the array and updating the regular GUI in the thread
                    if let temperatures = jsonResult[0]["values"] as? NSArray {
                        for temperature in temperatures {
                            print (Double(temperature["timestamp"]! as! Double))
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in // this is the main thread
                    })
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                    
                    if let temperatures = jsonResult[0]["values"] as? NSArray {
                        for temperature in temperatures {
                            print (Double(temperature["timestamp"]! as! Double))
                            var c:String = String(format:"%.1f", Double(temperature["timestamp"]! as! Double))
                            temperatureValues.append("Temp value: \(c)");
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in // this is the main thread
                        self.tableView.reloadData()
                    })
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = temperatureValues[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temperatureValues.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
}
