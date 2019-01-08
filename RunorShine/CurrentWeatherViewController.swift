//
//  CurrentWeatherViewController.swift
//  RunorShine
//
//  Created by Ryan DeBose-Boyd on 12/26/18.
//  Copyright © 2018 Ryan DeBose-Boyd. All rights reserved.
//

import UIKit
import CoreLocation


var main = [String]()
var temp = [Double]()

var mainArray = [String]()
var tempArray = [Double]()
var zipArray = [String]()
var dayNightArray = [Double]()
var cityArray = [String]()

var items: [Item] = []
var theGear = RunningGear()

var tempAsString = ""
var tempConvertedToF = 0
var tempConvertedToC = 0

var tempInt = 0

var sunrise = 0.0
var sunset = 0.0
var current = 0.0

var lat = 0.0
var lon = 0.0

var didFindLocation : Bool = true

class CurrentWeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    
    
    
    var threshold = 0
    //Will either be -15, 0, or +15 depending on if the user chose to dress light, normal, or heavy.

    
    
    
    
    @IBOutlet weak var cityTextField: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var conditionTextField: UILabel!
    
    
    @IBOutlet weak var tempTextField: UILabel!
    
   
    @IBOutlet weak var tableView: UITableView!
    
    
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
    items.removeAll()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            didFindLocation = false
        }
        
        lat = locationManager.location?.coordinate.latitude ?? 0.0
        lon = locationManager.location?.coordinate.longitude ?? 0.0
        
        
        getWeather()
        
        tableView.delegate = self
        tableView.dataSource = self
        print(threshold)
        
        
        
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
   
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // otherwise this function will be called every time when user location changes.
        if didFindLocation == false{
            didFindLocation = true
          
            //            coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            
        }
    }
    
    func getWeather() {
        
        
        let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5/weather?"
        let openWeatherMapAPIKey = "29a6f868beda8f74fc0ba8699c66b052"
        
        //Full URL https://api.openweathermap.org/data/2.5/weather?zip=75154&APPID=29a6f868beda8f74fc0ba8699c66b052
        //Gets Weather and converts it to JSON
        //This is a pretty simple networking task, so the shared session will do.
        
        // This is all for a GET Method, which is when you get some data from a URL (which is the weather in this case)
        
        // As opposed to a POST Method, where you would post a message to a forum, extending a database, etc.
        
        //        guard let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?zip=\(city)&APPID=\(openWeatherMapAPIKey)") else {
        //            return
        //        }
        
        //https://api.openweathermap.org/data/2.5/weather?lat=-32.53&lon=96.81&appid=29a6f868beda8f74fc0ba8699c66b052
        
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)lat=\(lat)&lon=\(lon)&appid=\(openWeatherMapAPIKey)")
        
        let session = URLSession.shared
        
        session.dataTask(with: weatherRequestURL!) { (data, response, error) in
//                        if let response = response {
//                            print(response)
//                        }
            
            if let data = data {
                print(data)//Prints out data in bytes. Have to convert it to JSON.
                //Converts data to JSON
                do {
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        
                        
                        //Creates an array for us to get the necessary info from the weather dictionary.
                        if let weatherArray = jsonObj?.value(forKey: "weather") as? NSArray {
                            
                            // Allows us to go inside the array of the weather dictionary to get the main description and the description.
                            for weather in weatherArray {
                                if let weatherDict = weather as? NSDictionary {
                                    if let main = weatherDict.value(forKey: "main"){
                                        mainArray.append(main as! String)
                                        
                                    }
                                    if let desc = weatherDict.value(forKey: "description") {
                                        mainArray.append(desc as! String)
                                    }
                                }
                            }
                        }//End of if statement 1
                        
                        //Gets sunrise and sunset for figuring out which background to use
                        if let sysArray = jsonObj?.value(forKey: "sys") as? NSDictionary {
                            
                            if let sunrise = sysArray.value(forKey: "sunrise") {
                                dayNightArray.append(sunrise as! Double)
                            }
                            if let sunset = sysArray.value(forKey: "sunset") {
                                dayNightArray.append(sunset as! Double)
                            }
                        }
                        
                        //Gets current time in Unix for figuring out which background to use
                        if let dt = jsonObj?.value(forKey: "dt") {
                            dayNightArray.append(dt as! Double)
                        }
                        
                        //Gets city name
                        if let name = jsonObj?.value(forKey: "name") {
                            cityArray.append(name as! String)
                        }
                        //Creates an array for us to get the necessary info from the main dictionary.
                        
                        if let mainArrayWithTemp = jsonObj?.value(forKey: "main") as? NSDictionary {
                            
                            // Allows us to go inside the dictionary of the main dictionary to get the main description and the description.
                            
                            if let temperature = mainArrayWithTemp.value(forKey: "temp"){
                                tempArray.append(temperature as! Double)
                                
                            }
                            
                            DispatchQueue.main.async{
                                
                                
                                
                                
                                
                                tempConvertedToF = Int(((tempArray[0] - 273.15) * (9/5) + (32.0)))
                                tempConvertedToC = Int((tempArray[0]-273.15))
                                if degrees == 1 {
                                    tempAsString = String(tempConvertedToF)
                                }
                                else {
                                    tempAsString = String(tempConvertedToC)
                                }
                                
                                mainArray.append(tempAsString)
                                
                                print(mainArray)
                                
                                self.conditionTextField.text! = mainArray[0]
                                self.tempTextField.text! = mainArray.last! + "º"
                                self.cityTextField.text! = cityArray.last!
                                cityArray.removeAll()
                                mainArray.removeAll()
                                tempArray.removeAll()
                                
                                sunrise = dayNightArray[0]
                                sunset = dayNightArray[1]
                                current = dayNightArray[2]

                                //Converts Sunrise and Sunset to Regular Time
                                
                                //                                let sunriseDate = Date(timeIntervalSince1970: TimeInterval(dayNightArray[0]))
                                //                                let sunsetDate = Date(timeIntervalSince1970: TimeInterval(dayNightArray[1]))
                                //                                let formatter = DateFormatter()
                                //                                formatter.dateStyle = .none
                                //                                formatter.timeStyle = .medium
                                //                                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                                //
                                //                                let sunriseFormattedTime = formatter.string(from: sunriseDate)
                                //                                print(sunriseFormattedTime)
                                //
                                //                                let sunsetFormattedTime = formatter.string(from: sunsetDate)
                                //                                print(sunsetFormattedTime)
                                
                                //Gets Items
                                
                                //Unwraps string value entered into temperature text field and converts it to an Int
                                
                                //                                if let tempOpt = (self.tempTextField.text)//Unwraps string optionsl
                                //                                {
                                //                                    if let tempIntOpt = Int(tempOpt)//Unwraps int optional
                                //                                    {
                                //                                        tempInt = Int(tempIntOpt)
                                //                                        print(tempInt)
                                
                                self.getItems()
                                //Gets Items based on weather
                                self.getWeatherIcons()
                                //Gets WeatherIcon
                            }
                        }//End of if let 2
                       
                    }//End of Do statement
                    
                }
                catch {
                    print(error)
                }
            }
            
            }.resume()//Known to work up to here
        
        //        mainArray.removeAll()
        //        tempArray.removeAll()
        
    }//End of getWeather
    
    func getItems() {
        
        tempConvertedToF = tempConvertedToF - threshold
        
        if tempConvertedToF >= 86 {
            
            items.append(theGear.items14)
            if !(current >= sunrise && current < sunset)
            {
                items[0].description = "It's warm enough outside, so ditch that shirt and enjoy the night air!"
            }
            else {
                items[0].description = "It's warm enough outside, so ditch that shirt, double up on sunblock, and go enjoy the sunshine!"
            }
            
            items.append(theGear.items2)
            print("TempconvertedToF is >=86")
        }
        
        if (75...85).contains(tempConvertedToF) {
            
            items.append(theGear.items1)
            items.append(theGear.items2)
            print("TempconvertedToF is between 75ºF and 85ºF")
            
        }
        
        //If Temp is from 45-74
        
        if (45...74).contains(tempConvertedToF){
            items.append(theGear.items3)
            items.append(theGear.items2)
            print("TempconvertedToF is between 45 and 74ºF")
        }
        
        //If Temp < 45
        if tempConvertedToF < 45 {
            items.append(theGear.items4)
            items.append(theGear.items2)
            print("TempconvertedToF is less than 45ºF")
        }
        
        //If Temp is <= 40
        if tempConvertedToF <= 40 {
            
            items.append(theGear.items5)
            items.append(theGear.items6)
            print("TempconvertedToF is less than = 40" )
        }
        // If Temp is <=35
        if tempConvertedToF <= 35 {
            items.remove(at: 1)//Removes Shorts
            items.append(theGear.items7)
            print("TempconvertedToF <= 35")
        }
        
        if tempConvertedToF <= 25 {
            items.append(theGear.items8)
            items.append(theGear.items15)
            print("TempconvertedToF <= 25")
            
        }
        
        //Unwraps string value entered into condition text field and converts it to string.
        
        if let condition = self.conditionTextField.text {
            var conditionText = String(condition)
            
            print(conditionText)
            print(tempConvertedToF)
            
            if conditionText == "Clear" && current >= sunrise && current < sunset && tempConvertedToF > 25
                
            {
                items.append(theGear.items9)
                items.append(theGear.items10)
                items.append(theGear.items11)
            }
            
            if (conditionText == "Rain" || conditionText == "Snow" || conditionText == "Drizzle")
            {
                if tempConvertedToF > 25 {
                    items.append(theGear.items9)
                }
                
                
                
            }
            
            if conditionText == "Snow" && tempConvertedToF > 60
            {
                items.removeAll()
                items.append(theGear.items12)
            }
            
            if conditionText == "Mist" || conditionText == "Smoke" || conditionText == "Haze" || self.conditionTextField.text! == "Fog"
            {
                if current >= sunrise && current < sunset
                {
                    items.append(theGear.items13)
                    //Adds Reflective gear if it is foggy, misty, or smoky outside during the day.
                }
            }
            
            if !(current >= sunrise && current < sunset) {
                items.append(theGear.items13)
                
            }
            self.tableView.reloadData()
            
            
            
        }//End of array of Items
    }//end of getItems()
    
    func getWeatherIcons() {
        
        
        //Gets Weather Icons
        if current >= sunrise && current < sunset
        {
            self.view.backgroundColor = UIColor.blue
            if self.conditionTextField.text! == "Clear" {
                self.weatherIcon.image = UIImage(named: "Sun")
            }
            if self.conditionTextField.text! == "Snow" {
                self.weatherIcon.image = UIImage(named: "Snow")
            }
            if self.conditionTextField.text! == "Rain" || self.conditionTextField.text! == "Drizzle" {
                self.weatherIcon.image = UIImage(named: "Rain")
            }
            if self.conditionTextField.text! == "Clouds" {
                self.weatherIcon.image = UIImage(named: "Cloudy")
            }
            if self.conditionTextField.text! == "Mist" || self.conditionTextField.text! == "Smoke" || self.conditionTextField.text! == "Haze" || self.conditionTextField.text! == "Fog" {
                self.weatherIcon.image = UIImage(named: "Mist")
                
                
            }
        }
            
        else {
            self.view.backgroundColor = UIColor.black
            if self.conditionTextField.text! == "Clear" {
                self.weatherIcon.image = UIImage(named: "Moony")
            }
            if self.conditionTextField.text! == "Snow" {
                self.weatherIcon.image = UIImage(named: "NightSnow")
            }
            if self.conditionTextField.text! == "Rain" || self.conditionTextField.text! == "Drizzle" {
                self.weatherIcon.image = UIImage(named: "NightRain")
            }
            if self.conditionTextField.text! == "Clouds" {
                self.weatherIcon.image = UIImage(named: "Cloudy")
            }
            if self.conditionTextField.text! == "Mist" || self.conditionTextField.text! == "Smoke" || self.conditionTextField.text! == "Haze" || self.conditionTextField.text! == "Fog" {
                self.weatherIcon.image = UIImage(named: "Mist")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        cell.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    //    prints out each element
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
//        if items[indexPath.row].name == "Tank Top" {
//            cell.imageView?.image = UIImage(named: "TankTop1")
//        }
//        if items[indexPath.row].name == "Shorts" {
//            cell.imageView?.image = UIImage(named: "Shorts2")
//        }
//        if items[indexPath.row].name == "Short-Sleeve T-Shirt" {
//            cell.imageView?.image = UIImage(named: "ShortSleeveShirt3")
//        }
//        if items[indexPath.row].name == "Long-Sleeve T-Shirt" {
//            cell.imageView?.image = UIImage(named: "LongSleeveShirt4")
//        }
//        if items[indexPath.row].name == "Jacket" {
//            cell.imageView?.image = UIImage(named: "LightJacket5")
//        }
//        if items[indexPath.row].name == "Gloves" {
//            cell.imageView?.image = UIImage(named: "Gloves6")
//        }
//        if items[indexPath.row].name == "Running Tights" {
//            cell.imageView?.image = UIImage(named: "Tights7")
//        }
//        if items[indexPath.row].name == "Beanie" {
//            cell.imageView?.image = UIImage(named: "Beanie8")
//        }
//        if items[indexPath.row].name == "Baseball cap"{
//            cell.imageView?.image = UIImage(named: "Cap9")
//        }
//        if items[indexPath.row].name == "Sunglasses" {
//            cell.imageView?.image = UIImage(named: "Sunglasses10")
//        }
//        if items[indexPath.row].name == "Sunblock" {
//            cell.imageView?.image = UIImage(named: "Sunblock11")
//        }
//        if items[indexPath.row].name == "Reflective gear" {
//            cell.imageView?.image = UIImage(named: "Reflective13")
//        }
//        if items[indexPath.row].name == "Go Shirtless" {
//            cell.imageView?.image = UIImage(named: "Shirtless214")
//        }
//        if items[indexPath.row].name == "Track pants" {
//            cell.imageView?.image = UIImage(named: "Pants15")
//        }
//        
        
        
        cell.textLabel?.text = items[indexPath.row].name + ":" + "\t\t" + items[indexPath.row].description
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let selectedItem = items[indexPath.row]
        
        performSegue(withIdentifier: "moveToItemDescription", sender: selectedItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let itemVC = segue.destination as? ItemDescriptionViewController {
            
            if let selectedItem = sender as? Item{
                itemVC.item = selectedItem
            }
            
            
        }
        
    }
    
    
    
    
    
    
    

    

}
