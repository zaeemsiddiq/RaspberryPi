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

class HistoryController: UIViewController, ServiceDelegate {

    @IBOutlet weak var fromDate: UIDatePicker!
    @IBOutlet weak var toDate: UIDatePicker!
    
    @IBOutlet weak var textLastN: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in // this is the main thread
                    })
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    

}
