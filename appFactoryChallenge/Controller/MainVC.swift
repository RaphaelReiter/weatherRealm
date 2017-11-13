//
//  MainVC.swift
//  appFactoryChallenge
//
//  Created by Raphaël Reiter on 12/11/2017.
//  Copyright © 2017 Raphaël Reiter. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import CoreLocation


class MainVC: UIViewController, CLLocationManagerDelegate, AddCityDelegate, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var CityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCityBtn: UIButton!
    
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    var fetchedCityWeather: Results<WeatherData>?
    var existingCityWeather: WeatherData?
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let passedCity = existingCityWeather {
            CityLabel.text = passedCity.city
            temperatureLabel.text = String(passedCity.temperature)
            
            if let imageNSData = passedCity.imageNSData as Data? {
                let image = UIImage(data: imageNSData)
                weatherImage.image = image
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let realm = try? Realm()
        fetchedCityWeather = realm?.objects(WeatherData.self).sorted(byKeyPath: "city", ascending: true)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("got weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
                self.CityLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateWeatherData(json: JSON) {
        let tempResult = json["main"]["temp"].doubleValue
        weatherDataModel.temperature = String(round(tempResult) - 273)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        updateUIWithWeatherData()
    }
    
    func updateUIWithWeatherData() {
        CityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherImage.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        CityLabel.text = "Location Unavailable"
    }
    
    func userEnteredANewCityName(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCityName" {
        let destinationVC = segue.destination as! addCityVC
            destinationVC.delegate = self
        }
    }
    
    @IBAction func saveToFavoritesBtnWasPressed(_ sender: Any) {
        var newCity: WeatherData!
        
        if existingCityWeather == nil {
            newCity = WeatherData()
            if let city = CityLabel.text {
                newCity.city = city
            }
            if let temperature = temperatureLabel.text {
                newCity.temperature = temperature
            }
            
            if let image = weatherImage.image {
                if let nsData = UIImageJPEGRepresentation(image, 0.5) as NSData? {
                    newCity.imageNSData = nsData
                }
            }
            
            let realm = try? Realm()
            try? realm?.write {
                realm?.add(newCity)
            }
            
        } else {
            newCity = existingCityWeather
            
            let realm = try? Realm()
            try? realm?.write {
                if let city = CityLabel.text {
                    newCity.city = city
                }
                if let temperature = temperatureLabel.text {
                    newCity.temperature = temperature
                    
                }
                
                if let image = weatherImage.image {
                    if let nsData = UIImageJPEGRepresentation(image, 0.5) as NSData? {
                        newCity.imageNSData = nsData
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedCityWeather?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as? weatherCell else { return UITableViewCell() }
        
        let cityWeather = fetchedCityWeather?[indexPath.row]
        cell.configureCell(cityWeather: cityWeather!)
        return cell
    }
    
}


































