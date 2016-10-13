//
//  SettingsController.swift
//  RaspberryPi
//
//  Created by Zaeem Siddiq on 10/9/16.
//  Copyright © 2016 Zaeem Siddiq. All rights reserved.
//
/* 
 This view controller is dealing with user settings. The main methods in this controller are to write and read settings to and from a settings file.
 This class after reading in the values from file stores them into the Constants variables which are accessed throughout the application's lifecycle. Such as, thmperatureThreshold and notify.
 */

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var textThreshold: UITextField!
    @IBOutlet weak var switchNotify: UISwitch!
    var notify: Bool!
    var threshold: Int!
    var text = "T:30,N:1"
    override func viewDidLoad() {
        super.viewDidLoad()
        readFromFile()
    }
    
    // Saving the values from the user inputs to a file. Performing validation as well to ignore invalid inputs.
    @IBAction func buttonSave(sender: AnyObject) {
        var isValid: Bool = true    // used to check if the inputs are valid or not
        var message: String = ""    // the message that is generated in case if the values are not valid
        if textThreshold.text == "" {   // checking empty
            isValid = false
            message = "Value cannot be empty"
        } else {
            let num = Int(textThreshold.text!)  // checking if the number is not a valid integer
            if num == nil  {
                isValid = false
                message = "Please enter a valid number"
            }
        }
        if isValid {    // all good, write to file now and generate a success notifcation message
            writeToFile()
            generateNotification("Success", message: "Settings Saved Successfully")
        } else {
            textThreshold.text = ""
            generateNotification("Input Error", message: message)
        }
        
    }
    
    // this method generates a notification on.
    func generateNotification(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // the wirtefile stores two objects on one single line i.e. T:23,N:0
    // T can be any temperature value set by the user and N can be either 0 or 1 bool true or false.
    func writeToFile() {
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(Constants.fileName)
            
            //writing
            do {
                Constants.temperatureThreshold = Int(textThreshold.text!)!
                Constants.notify = switchNotify.on ? true : false
                text = "T:\(textThreshold.text!),N:\(switchNotify.on ? "1" : "0")"
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
        }
    }
    
    func readFromFile() {
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(Constants.fileName)
            
            //reading and creating tokens, first token would be a split on the basis of, so that we get 2 values T and N, then splitting on the basis of , so that we again get two values one for N and one for T
            do {
                let text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                var tokens = text2.componentsSeparatedByString(",") // ["T:0", "N:0"]
                var token1 = tokens[0].componentsSeparatedByString(":")
                var token2 = tokens[1].componentsSeparatedByString(":")
                
                threshold = Int(token1[1])
                textThreshold.text = String(threshold)
                Constants.temperatureThreshold = threshold;
                if token2[1] == "0" { // false
                    Constants.notify = false
                    switchNotify.setOn(false, animated: true)
                } else {
                    Constants.notify = true
                    switchNotify.setOn(true, animated: true)
                }
            }
            catch {/* error handling here */}
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
