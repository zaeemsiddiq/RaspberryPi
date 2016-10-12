//
//  SensorValuesController.swift
//  RaspberryPi
//
//  Created by Zaeem Siddiq on 10/9/16.
//  Copyright © 2016 Zaeem Siddiq. All rights reserved.
//

import UIKit

class SensorValuesController: UIViewController, ServiceDelegate {

    @IBOutlet weak var labelRed: UILabel!
    @IBOutlet weak var labelGreen: UILabel!
    @IBOutlet weak var labelBlue: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    
    
    let shapeLayer = CAShapeLayer()
    var timer: NSTimer!
    var sensorTemp: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCircle()
        readFromFile()
        startTimer()
        //stopTimer()
        
        // Do any additional setup after loading the view.
    }
    
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(Constants.interval, target: self, selector: #selector(check), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
        timer=nil
    }
    
    
    func check() {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            let tempService = HttpRequestService(delegate: self)
            tempService.getTemp()
            
            let rgbService = HttpRequestService(delegate: self)
            rgbService.getColorReading()
        })
    }
    
    func didReceiveError(error:String) {
        
    }
    func serviceComplete(data: NSData, functionCall: String) {
        if functionCall == HttpRequestService.GET_TEMP {
            parseCurrentTemperature(data)
        } else if functionCall == HttpRequestService.GET_COLOR_READING {
            parseColorData(data)
        }
    }
    
    func parseColorData(data: NSData) {
        do {
            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                
                
                let sensorColor = UIColor(red: Int(jsonResult["red"]! as! NSNumber), green: Int(jsonResult["green"]! as! NSNumber), blue: Int(jsonResult["blue"]! as! NSNumber))
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in // this is the main thread
                
                    self.labelRed.text = String(jsonResult["red"]!)
                    self.labelGreen.text = String(jsonResult["green"]!)
                    self.labelBlue.text = String(jsonResult["blue"]!)
                    
                    //change the fill color
                    self.shapeLayer.fillColor = sensorColor.CGColor
                    //you can change the stroke color
                    self.shapeLayer.strokeColor = UIColor.whiteColor().CGColor
                    //you can change the line width
                    self.shapeLayer.lineWidth = 3.0
                    
                })
                
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func parseCurrentTemperature(data: NSData) {
        do {
            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                
                //print("\(jsonResult)")
                if let item = jsonResult["values"] as? [NSObject: AnyObject] {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in // this is the main thread
                        
                        self.labelTemperature.text = String(item["temperature"]!)
                        self.sensorTemp = Int(String(item["temperature"]!))
                        print("sensor\(self.sensorTemp) - target: \(Constants.temperatureThreshold)")
                        if self.sensorTemp > Constants.temperatureThreshold {
                            // Notify the user when they have entered a region
                            let title = "Temperature Notification"
                            let message = "Temperature value is rising the threshold"
                            
                            if UIApplication.sharedApplication().applicationState == .Active {
                                // App is active, show an alert
                                let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                alertController.addAction(alertAction)
                                self.presentViewController(alertController, animated: true, completion: nil)
                            } else {
                                // App is inactive, show a notification
                                let notification = UILocalNotification()
                                notification.alertTitle = title
                                notification.alertBody = message
                                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                            }
                            
                        }
                    })
                    //print("temp is: \(item["temperature"]!)")
                    
                }
                
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCircle() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 200,y: 280), radius: CGFloat(70), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        
        shapeLayer.path = circlePath.CGPath
        view.layer.addSublayer(shapeLayer)
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
               
                Constants.temperatureThreshold = Int(token1[1])!
                if token2[1] == "0" { // false
                   Constants.notify = false
                } else {
                    Constants.notify = true
                }
            }
            catch {/* error handling here */}
        }
    }

}
