//
//  StartingViewController.swift
//  RunorShine
//
//  Created by Ryan DeBose-Boyd on 12/25/18.
//  Copyright © 2018 Ryan DeBose-Boyd. All rights reserved.
//


import UIKit



//Defaults temperature to be displayed in ºF
var degrees = 1

//Defaults to dressing normal
var dress = "Normal"


class StartingViewController: UIViewController {



    @IBAction func dressOption(_ sender: Any) {

        if (sender as AnyObject).selectedSegmentIndex == 0 {
            dress = "Light"
            print("User wants to dress lightly")


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

