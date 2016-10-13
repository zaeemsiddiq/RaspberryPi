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
    func serviceComplete(data: NSData, functionCall: String)
}
class HttpRequestService: NSObject {
    var delegate:ServiceDelegate!
    var functionCall:String!
    
    let ipAdd: String = "http://118.139.10.151:3000"
    let weatherAPI: String = "http://api.openweathermap.org/data/2.5/"
    
    static var GET_TEMP: String = "currentTemperature"
    static var GET_TEMP_N: String = "temperature/:num"
    static var GET_TEMP_BY_DATE: String = "temperature/:start/:end"
    static var GET_COLOR_READING: String = "color_reading"
    static var GET_WEATHER: String = "weather?lat=-37.8825100&lon=145.0228800&appid=a061487dc92e5d3c37f092f10fe966f9&units=metric"


    
    init(delegate: ServiceDelegate) {
        self.delegate = delegate
    }
    
    
    func getTemp() {
        self.functionCall = HttpRequestService.GET_TEMP
        callPiNodeService(self.functionCall)
        
    }
    
    func getTempN(N: Int) {
        self.functionCall = HttpRequestService.GET_TEMP_N
        
        var unwrappedCall = HttpRequestService.GET_TEMP_N
        unwrappedCall = unwrappedCall.stringByReplacingOccurrencesOfString(":num", withString: String(N), options: NSStringCompareOptions.LiteralSearch, range: nil)
        callPiNodeService(unwrappedCall)
        
    }
    
    func getTempBydate(startUtc: String, endUtc: String) {
        self.functionCall = HttpRequestService.GET_TEMP_BY_DATE
        var unwrappedCall = HttpRequestService.GET_TEMP_BY_DATE
        unwrappedCall = unwrappedCall.stringByReplacingOccurrencesOfString(":start", withString: startUtc, options: NSStringCompareOptions.LiteralSearch, range: nil)
        unwrappedCall = unwrappedCall.stringByReplacingOccurrencesOfString(":end", withString: endUtc)
        
        callPiNodeService(unwrappedCall)
    }
    
    func getColorReading() {
        self.functionCall = HttpRequestService.GET_COLOR_READING
        callPiNodeService(self.functionCall)
    }
    
    func callPiNodeService(funcCall: String){
        
        let url : String = "\(ipAdd)/\(funcCall)"
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        request.timeoutInterval = 60
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if data != nil {
                self.delegate.serviceComplete(data!, functionCall: self.functionCall)
            }
        })
    }
    
    func sendRequest(url: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionTask {
        let requestURL = NSURL(string:"https://\(ipAdd)/\(functionCall!)")!
        
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler:completionHandler)
        task.resume()
        
        return task
    }
    
    func loadedData(data:NSData!,response:NSURLResponse!,err:NSError!){
        if(err != nil){
            print(err?.description)
        }else{
            print(data)
            
        }
    }
    
    
    func getCurrentWeather() {
        self.functionCall = HttpRequestService.GET_WEATHER
        callWeatherService(functionCall)
    }
    
    
    func callWeatherService(funcCall: String){
        
        let url : String = "\(weatherAPI)/\(funcCall)"
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        request.timeoutInterval = 60
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if data != nil {
                self.delegate.serviceComplete(data!, functionCall: self.functionCall)
            }
        })
    }
    
    
    
    
    
}
