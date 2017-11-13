//
//  WeatherData.swift
//  appFactoryChallenge
//
//  Created by Raphaël Reiter on 12/11/2017.
//  Copyright © 2017 Raphaël Reiter. All rights reserved.
//

import UIKit
import RealmSwift

class WeatherData: Object {
    @objc dynamic var temperature: String = ""
    @objc dynamic var condition: Int = 0
    @objc dynamic var city : String = ""
    @objc dynamic var weatherIconName : String = ""
    @objc dynamic var imageNSData: NSData?
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...800 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }

}
