//
//  HistoryController.swift
//  RaspberryPi
//
//  Created by Zaeem Siddiq on 10/9/16.
//  Copyright © 2016 Zaeem Siddiq. All rights reserved.
//

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
        let num = textLastN.text
        let tempService = HttpRequestService(delegate: self)
        tempService.getTempN(Int(num!)!)
    }
    
    
    func didReceiveError(error:String) {
        
    }
    func serviceComplete(data: NSData, functionCall: String) {
        if functionCall == HttpRequestService.GET_TEMP_N {
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
