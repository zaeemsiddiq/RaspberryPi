//
//  SettingsController.swift
//  RaspberryPi
//
//  Created by Zaeem Siddiq on 10/9/16.
//  Copyright © 2016 Zaeem Siddiq. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var textThreshold: UITextField!
    @IBOutlet weak var switchNotify: UISwitch!
    var notify: Bool!
    var threshold: Int!
    var text = "T:30,N:0"
    override func viewDidLoad() {
        super.viewDidLoad()
        readFromFile()
    }
    
    @IBAction func buttonSave(sender: AnyObject) {
        writeToFile()
    }
    func writeToFile() {
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(Constants.fileName)
            
            //writing
            do {
                text = "T:\(textThreshold.text!),N:\(switchNotify.on ? "1" : "0")"
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
        }
    }
    
    func readFromFile() {
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(Constants.fileName)
            
            //reading
            do {
                let text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                var tokens = text2.componentsSeparatedByString(",") // ["T:0", "N:0"]
                var token1 = tokens[0].componentsSeparatedByString(":")
                var token2 = tokens[1].componentsSeparatedByString(":")
                
                threshold = Int(token1[1])
                textThreshold.text = String(threshold)
                Constants.temperatureThreshold = threshold;
                if token2[1] == "0" { // false
                    switchNotify.setOn(false, animated: true)
                } else {
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
