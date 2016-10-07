//
//  ViewController.swift
//  RaspberryPi
//
//  Created by Zaeem Siddiq on 10/7/16.
//  Copyright © 2016 Zaeem Siddiq. All rights reserved.
//

import UIKit



class ViewController: UIViewController, ServiceDelegate {

    @IBOutlet weak var labelText: UILabel!
    let shapeLayer = CAShapeLayer()
    
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        addCircle()
        
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.check), userInfo: nil, repeats: true)
        
    }
    
    func addCircle() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 300), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        
        shapeLayer.path = circlePath.CGPath
        view.layer.addSublayer(shapeLayer)
    }
    
    func didReceiveError(error:String) {
        
    }
    func serviceComplete(data: NSData) {
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in // this is the main thread
            if self.counter % 2 == 0 {
                self.labelText.textColor = UIColor.brownColor()
                
                //change the fill color
                self.shapeLayer.fillColor = UIColor.brownColor().CGColor
                //you can change the stroke color
                self.shapeLayer.strokeColor = UIColor.redColor().CGColor
                //you can change the line width
                self.shapeLayer.lineWidth = 3.0
            } else {
                let newSwiftColor = UIColor(red: 255, green: 165, blue: 0)
                self.labelText.textColor = newSwiftColor
                
                
                //change the fill color
                self.shapeLayer.fillColor = newSwiftColor.CGColor
                //you can change the stroke color
                self.shapeLayer.strokeColor = UIColor.redColor().CGColor
                //you can change the line width
                self.shapeLayer.lineWidth = 3.0
            }
            
        })
        
        
        
        do {
            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                
                print("ASynchronous\(jsonResult)")
                if let item = jsonResult["headers"] as? [NSObject: AnyObject] {
                    print("json size is \(item)")
                }
                
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func check() {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            
            let service = HttpRequestService(delegate: self)
            service.callPiNodeService()
            self.counter+=1
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in // this is the main thread
                
                
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

