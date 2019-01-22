//
//  StartingViewController.swift
//  RunorShine
//
//  Created by Ryan DeBose-Boyd on 12/25/18.
//  Copyright © 2018 Ryan DeBose-Boyd. All rights reserved.
//


import UIKit



let degreesKey = "Degrees"
let dressKey = "Dress"



class StartingViewController: UIViewController {
    
    var dress: Int = Int()
    
    var degrees: Int = Int()
    
    override func viewDidLoad() {
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
        
        self.navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func doneWithSettings(_ sender: Any) {
        
        
    }
    @IBOutlet weak var dressOption: UISegmentedControl!
    
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
    
    @IBOutlet weak var tempOption: UISegmentedControl!
    
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
    
   

            

}

