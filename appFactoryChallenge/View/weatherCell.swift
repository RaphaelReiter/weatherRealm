//
//  weatherCell.swift
//  appFactoryChallenge
//
//  Created by Raphaël Reiter on 12/11/2017.
//  Copyright © 2017 Raphaël Reiter. All rights reserved.
//

import UIKit
import RealmSwift

class weatherCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    
    func configureCell(cityWeather: WeatherData) {
        self.cityName.text = cityWeather.city
        self.temperatureLbl.text = String(cityWeather.temperature)
      
    }
}
