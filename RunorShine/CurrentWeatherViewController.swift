//
//  CurrentWeatherViewController.swift
//  RunorShine
//
//  Created by Ryan DeBose-Boyd on 12/26/18.
//  Copyright © 2018 Ryan DeBose-Boyd. All rights reserved.
//

import UIKit
import CoreLocation
import Reachability




var theGear = RunningGear()


class CurrentWeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    var didFindLocation : Bool = true


    var main = [String]()
    var temp = [Double]()
    
    var mainArray = [String]()
    var tempArray = [Double]()
    var zipArray = [String]()
    var dayNightArray = [Double]()
    var cityArray = [String]()
    
    var items: [Item] = []
    
    var tempAsString = ""
    var tempConvertedToF = 0
    var tempConvertedToC = 0
    
    var tempInt = 0
    
    var lat = 0.0
    var lon = 0.0
    
    var sunrise = 0.0
    var sunset = 0.0
    var current = 0.0

    var conditionTextField = ""
    var tempTextField = ""
    
    var airplane = false
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    var locationManager: CLLocationManager!
    
    @objc func refreshWeather(_ sender: Any) {
        if airplane == false
        {
            print("refreshing...")
            getWeather()
        }
    }
    
   var internetReachability = Reachability()
    
    override func viewDidLoad() {
        
        
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
        if (lat == 0.0 && lon == 0.0)
        {
            print("Could not find location. Please try again.")
        }
        
        if airplane == false
        {
        getWeather()
        
            self.tableView.tableFooterView = UIView()
            
            super.viewDidLoad()
            
            //Add Refresh Conrol to Table View
            if #available(iOS 10.0, *) {
                refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
                self.tableView.refreshControl = refreshControl
            }
            else {
                refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
                tableView.addSubview(refreshControl)
            }
            
            // Configure Refresh Control
            refreshControl.addTarget(self, action: #selector(refreshWeather(_:)), for: .valueChanged)
            
            DataManager.shared.weatherVC = self
            
            
            // Do any additional setup after loading the view.
        
        }
        else {
            print ("No connection.")
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: internetReachability)
        do {
            try internetReachability?.startNotifier()
        }
        catch{
            print("Could not start reachability notifier")
        }
        
    }
   
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("Reachable via Wifi")
            airplane = false
        case .cellular:
            print("Reachable via Cellular")
            airplane = false
        case .none:
            print("Network not reachable")
            airplane = true
            
    }
    }
    
    func getThreshold() -> Int {
       
        //Will either be -15, 0, or +15 depending on if the user chose to dress light, normal, or heavy.
        var dress: Int = UserDefaults.standard.integer(forKey: dressKey)
        var threshold: Int = Int()
        
        switch dress {
            
        case 0:
            threshold = -15
        case 2:
            threshold = 15
        default:
            threshold = 0
        }
        return threshold
    }
    
    func getTempSetting() -> Int {
        var tempsetting: Int = UserDefaults.standard.integer(forKey: degreesKey)
        return tempsetting
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
        
        
        mainArray.removeAll()
        dayNightArray.removeAll()
        cityArray.removeAll()
        tempArray.removeAll()
        
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
                                        self.mainArray.append(main as! String)
                                        
                                    }
                                    if let desc = weatherDict.value(forKey: "description") {
                                        self.mainArray.append(desc as! String)
                                    }
                                }
                            }
                        }//End of if statement 1
                        
                        //Gets sunrise and sunset for figuring out which background to use
                        if let sysArray = jsonObj?.value(forKey: "sys") as? NSDictionary {
                            
                            if let sunrise = sysArray.value(forKey: "sunrise") {
                                self.dayNightArray.append(sunrise as! Double)
                            }
                            if let sunset = sysArray.value(forKey: "sunset") {
                                self.dayNightArray.append(sunset as! Double)
                            }
                        }
                        
                        //Gets current time in Unix for figuring out which background to use
                        if let dt = jsonObj?.value(forKey: "dt") {
                            self.dayNightArray.append(dt as! Double)
                        }
                        
                        //Gets city name
                        if let name = jsonObj?.value(forKey: "name") {
                            self.cityArray.append(name as! String)
                        }
                        //Creates an array for us to get the necessary info from the main dictionary.
                        
                        if let mainArrayWithTemp = jsonObj?.value(forKey: "main") as? NSDictionary {
                            
                            // Allows us to go inside the dictionary of the main dictionary to get the main description and the description.
                            
                            if let temperature = mainArrayWithTemp.value(forKey: "temp"){
                                self.tempArray.append(temperature as! Double)
                                
                            }
                            
                            DispatchQueue.main.async{
                                
                                self.tempConvertedToF = Int(((self.tempArray.last! - 273.15) * (9/5) + (32.0)))
                                self.tempConvertedToC = Int((self.tempArray.last! - 273.15))
                                let tempDisplay = self.getTempSetting()
                                
                                if tempDisplay == 1 {
                                    self.tempAsString = String(self.tempConvertedToF)
                                }
                                else {
                                    self.tempAsString = String(self.tempConvertedToC)
                                }
                                
                                self.mainArray.append(self.tempAsString)
                                
                                
                                print(self.mainArray)
                                
                                self.tempArray.removeAll()
                                
                                self.conditionTextField = self.mainArray[0]
                                self.tempTextField = self.mainArray.last!
                                self.sunrise = self.dayNightArray[0]
                                self.sunset = self.dayNightArray[1]
                                self.current = self.dayNightArray[2]

                            }
                        }//End of if let 2
                        DispatchQueue.main.async {
                            self.getItems()
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                       self.tableView.reloadData()
                        
                            
                            self.refreshControl.endRefreshing()
                            
                        }
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
        items.removeAll()

        tempConvertedToF = tempConvertedToF - (self.getThreshold())

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

        //Gets items based on certain conditions.


            if self.conditionTextField == "Clear" && current >= sunrise && current < sunset && tempConvertedToF > 25

            {
                items.append(theGear.items9)
                items.append(theGear.items10)
                items.append(theGear.items11)
            }

            if (self.conditionTextField == "Rain" || self.conditionTextField == "Snow" || self.conditionTextField == "Drizzle")
            {
                if tempConvertedToF > 25 {
                    items.append(theGear.items9)
                }

            }

            if self.conditionTextField == "Snow" && tempConvertedToF > 60
            {
                items.removeAll()
                items.append(theGear.items12)
            }

            if self.conditionTextField == "Mist" || self.conditionTextField == "Smoke" || self.conditionTextField == "Haze" || self.conditionTextField == "Fog"
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
    }//end of getItems()
    

    func getWeatherIcons(condition: String, currentTime: Double, sunriseTime: Double, sunsetTime: Double) -> UIImage {
        
        var weatherImage: UIImage = UIImage()
        
        //Gets Weather Icons
        if current >= sunrise && current < sunset
        {
            
            if self.conditionTextField == "Clear" {
                weatherImage = UIImage(named: "Sun")!
            }
            if self.conditionTextField == "Snow" {
                weatherImage   = UIImage(named: "Snow")!
            }
            if self.conditionTextField == "Rain" || self.conditionTextField == "Drizzle" {
                weatherImage   = UIImage(named: "Rain")!
            }
            if self.conditionTextField == "Clouds" {
                weatherImage   = UIImage(named: "Cloudy")!
            }
            if self.conditionTextField == "Mist" || self.conditionTextField == "Smoke" || self.conditionTextField == "Haze" || self.conditionTextField == "Fog" {
                weatherImage   = UIImage(named: "Mist")!
            }
        }

        else {
            
            if self.conditionTextField == "Clear" {
                weatherImage  = UIImage(named: "Moony")!
            }
            if self.conditionTextField == "Snow" {
                weatherImage  = UIImage(named: "NightSnow")!
            }
            if self.conditionTextField == "Rain" || self.conditionTextField == "Drizzle" {
                weatherImage  = UIImage(named: "NightRain")!
            }
            if self.conditionTextField == "Clouds" {
                weatherImage  = UIImage(named: "Cloudy")!
            }
            if self.conditionTextField == "Mist" || self.conditionTextField == "Smoke" || self.conditionTextField == "Haze" || self.conditionTextField == "Fog" {
                weatherImage  = UIImage(named: "Mist")!
            }
        }
        return weatherImage
    }//End of getWeatherIcons()
    
    func getBackgroundColor() -> UIColor {
        var itIsDayLight = true
        
        var color: UIColor = UIColor()
        
        if current >= sunrise && current < sunset {
            print(itIsDayLight)
            color = UIColor(red: 0.24, green: 0.56, blue: 0.72, alpha: 1)
        }
        else {
            itIsDayLight = false
            print(itIsDayLight)
            color = UIColor.black
        }
        
        return color
        
    }//End of getBackGroundColor()

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        cell.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + items.count
        
    }
    
    //    prints out each element
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let customFont = UIFont(name: "MavenProRegular", size: UIFont.labelFontSize) else {
            fatalError("""
Failed to load the "MavenProRegular" font.
Make sure the font file is included in the project and that the font name is spelled correctly.
"""
            )
            
        }
        
        
 
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityName") as! CityNameTableViewCell
            
            cell.cityTextField.text! = cityArray.last!
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.contentView.backgroundColor = self.getBackgroundColor()
            cell.cityTextField.font = UIFont(name: "MavenProRegular", size: 30)


            return cell
            

        }
        
        if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell (withIdentifier: "weatherIcon") as! WeatherIconTableViewCell
            
            print(conditionTextField, current, sunrise, sunset)
            cell.weatherIcon.image = self.getWeatherIcons(condition: conditionTextField, currentTime: current, sunriseTime: sunrise, sunsetTime: sunset)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.contentView.backgroundColor = self.getBackgroundColor()
            tableView.separatorStyle = .none
            
            self.tableView.tableFooterView = UIView(frame: .zero)
            return cell
            
            
        }
        
        if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentWeather") as! CurrentWeatherTableViewCell
            

            cell.tempTextField.font = UIFont(name: "MavenProRegular", size: 45)
            cell.conditionTextField.font = UIFont(name: "MavenProRegular", size: 23)
                cell.tempTextField.text! = mainArray.last! + "º"
            cell.conditionTextField.text! = self.conditionTextField
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.contentView.backgroundColor = self.getBackgroundColor()
            
            self.tableView.tableFooterView = UIView(frame: .zero)
            
            return cell
            
            
        }
        
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "items", for: indexPath) as! ItemTableViewCell
            
            cell.itemLabel.text = items[indexPath.row - 3].name
            
            
            cell.itemLabel.adjustsFontForContentSizeCategory = true
            
            cell.itemImage.image = theGear.getItemImages(itemName: items[indexPath.row - 3].name)
            cell.descriptionLabel.text = items[indexPath.row - 3].description
            print(indexPath.row)
            let relativeFontConstant1: CGFloat = 0.020
            let relativeFontConstant2: CGFloat = 0.030
            var screenSize = self.view.frame.height
            var fontSize1 = relativeFontConstant1 * screenSize
            var fontSize2 = relativeFontConstant2 * screenSize
            
            cell.descriptionLabel.font = UIFont(name: "MavenProRegular", size: fontSize1)
           
            
            cell.itemLabel.font = UIFont(name: "MavenProRegular", size: fontSize2)
            
            
//            cell.contentView.backgroundColor = UIColor.cyan
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            self.tableView.tableFooterView = UIView(frame: .zero)
          
            cell.contentView.backgroundColor = UIColor.lightGray
            
            return cell
        
        }
        
        return UITableViewCell()
        
    
    }
    
    // Screen height
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        }
        else if indexPath.row > 2 {
            return self.screenHeight / (CGFloat(Float(items.count)))
        }
        else {
            return 100
        }
        
    }
    
}
