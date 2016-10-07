//
//  HttpRequestService.swift
//  RaspberryPi
//
//  Created by Zaeem Siddiq on 10/8/16.
//  Copyright © 2016 Zaeem Siddiq. All rights reserved.
//

import Foundation

protocol ServiceDelegate {
    func didReceiveError(error:String)
    func serviceComplete(data: NSData)
}
class HttpRequestService: NSObject {
    var delegate:ServiceDelegate!
    var functionCall:String!
    let urlPath: String = "https://httpbin.org/get"

    
    init(delegate: ServiceDelegate) {
        self.delegate = delegate
    }
    
    func callPiNodeService(){
        
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in            
            self.delegate.serviceComplete(data!)
            
        })
    }
}
