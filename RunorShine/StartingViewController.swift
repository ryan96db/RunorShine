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
var degrees = 1

//Defaults to dressing normal
var dress = "Normal"


class StartingViewController: UIViewController, CLLocationManagerDelegate {

    
   
    @IBAction func dressOption(_ sender: Any) {
        
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            dress = "Light"
            print("User wants to dress lightly")
            print(dress)
            
        }
        //If user changes from default, then comes back to normal
        else if (sender as AnyObject).selectedSegmentIndex == 1 {
            dress = "Normal"
            print("User wants to dress normal")
            print(dress)
            
        }
        else if (sender as AnyObject).selectedSegmentIndex == 2 {
            dress = "Heavy"
            print("User wants to dress heavy")
            print(dress)
        }
    
    }
    
 
    @IBAction func tempOption(_ sender: Any) {
        
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
        
    }
    
    
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        
        //Defaults to dress normal
        print(dress)
        //Defaults temperature to be displayed in ºF
        print(degrees)
        super.viewDidLoad()
        
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
                
            case "Light":
                currentWeatherVC.threshold = -15
            case "Heavy":
                currentWeatherVC.threshold = 15
            default:
                currentWeatherVC.threshold = 0
                
            }
           
            
            
          
        }
    }

}

