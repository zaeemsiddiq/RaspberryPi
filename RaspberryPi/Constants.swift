//
//  File.swift
//  RaspberryPi
//
//  Created by Zaeem Siddiq on 10/8/16.
//  Copyright © 2016 Zaeem Siddiq. All rights reserved.
//

import Foundation
import UIKit

// code taken from http://www.codingexplorer.com/create-uicolor-swift/ , converts rgb to  a UI COLOR
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

class Constants {
    static var temperatureThreshold: Int = 25
    static var notify: Bool = true
    static var fileName = "file.txt"
    static var interval: Double = 0.5
    static var popupTimerInterval: Double = 10 // seconds
    static var weatherDifference: Double = 10
}