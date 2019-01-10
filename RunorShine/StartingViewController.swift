//
//  StartingViewController.swift
//  RunorShine
//
//  Created by Ryan DeBose-Boyd on 12/25/18.
//  Copyright © 2018 Ryan DeBose-Boyd. All rights reserved.
//


import UIKit


import CoreLocation


var lat = 0.0
var lon = 0.0

var didFindLocation : Bool = true

var coordinates = [CLLocationCoordinate2D]()

//Defaults temperature to be displayed in ºF
var degrees = -1

//Defaults to dressing normal




class StartingViewController: UIViewController, CLLocationManagerDelegate {
    
    var dress = -1
    
    let degreesKey = "Degrees"
    let dressKey = "Dress"
    
    @IBAction func dressOptionChanged(_ sender: Any) {
        
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            dress = 0
            print("User wants to dress lightly")
            print("Dress:\(dress)")
            
            
        }
            //If user changes from default, then comes back to normal
        else if (sender as AnyObject).selectedSegmentIndex == 1 {
            dress = 1
            print("User wants to dress normal")
            print("Dress:\(dress)")
            
        }
        else if (sender as AnyObject).selectedSegmentIndex == 2 {
            dress = 2
            print("User wants to dress heavy")
            print("Dress:\(dress)")
        }
        
         UserDefaults.standard.set(dress, forKey: dressKey)
        
    }
    
    @IBAction func tempOptionChanged(_ sender: Any) {
        
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            degrees = 0
            print("User wants ºC")
            print(degrees)
        }
        else {
            //If user changes to ºC, then changes it back to ºF
            print("User wants ºF")
            degrees = 1
            print(degrees)
        }
        
        UserDefaults.standard.set(degrees, forKey: degreesKey)

    }
    
    @IBOutlet weak var dressOption: UISegmentedControl!
    
    @IBOutlet weak var tempOption: UISegmentedControl!
    
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        
//        //Defaults to dress normal
//        print(dress)
//        //Defaults temperature to be displayed in ºF
//        print(degrees)
        super.viewDidLoad()
        
        if let tempDisplay = UserDefaults.standard.value(forKey: degreesKey) {
            tempOption.selectedSegmentIndex = tempDisplay as! Int
            print(tempDisplay)
            degrees = tempDisplay as? Int ?? 1
            //Saves User temperature preference
        }
        if let dressPreference = UserDefaults.standard.value(forKey: dressKey) {
            dressOption.selectedSegmentIndex = dressPreference as! Int
            print(dressPreference)
            dress = dressPreference as? Int ?? 1
            //Saves User dress preference

        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            didFindLocation = false
        }
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
            
            lat = userLocation.coordinate.latitude
            lon = userLocation.coordinate.longitude
            
//            coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            performSegue(withIdentifier: "moveToCurrentWeather", sender: (Any).self)
            
        }
    }

    @IBAction func getCurrentWeather(_ sender: Any) {
        
        determineMyCurrentLocation()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "moveToCurrentWeather") {
            
             let currentWeatherVC = segue.destination as! CurrentWeatherViewController
            switch dress {
                
            case 0:
                currentWeatherVC.threshold = -15
            case 2:
                currentWeatherVC.threshold = 15
            default:
                currentWeatherVC.threshold = 0
            
           
            
                
            }
            
            
            
            
            
           
            
            
          
        }
    }

}

