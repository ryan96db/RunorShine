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
    
    
    @IBOutlet weak var DressLabel: UILabel!
    
    
    @IBOutlet weak var TempLabel: UILabel!
    var dress: Int = Int()
    
    var degrees: Int = Int()
    
    
    
    override func viewDidLoad() {
        tempOption.selectedSegmentIndex = 0
        if let tempDisplay = UserDefaults.standard.value(forKey: degreesKey) {
            tempOption.selectedSegmentIndex = tempDisplay as! Int
            print(tempDisplay)
            degrees = tempDisplay as? Int ?? 0
            //Saves User temperature preference
            
        }
        if let dressPreference = UserDefaults.standard.value(forKey: dressKey) {
            dressOption.selectedSegmentIndex = dressPreference as! Int
            print(dressPreference)
            dress = dressPreference as? Int ?? 1
            //Saves User dress preference
        }
    
        let color = UIColor(red: 0.24, green: 0.56, blue: 0.72, alpha: 1)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black

        self.navigationItem.title = "Settings"
        
        self.view.backgroundColor = color
        self.navigationItem.hidesBackButton = true
        self.DressLabel.font = UIFont(name: "MavenProRegular", size: 24)
        self.TempLabel.font = UIFont(name: "MavenProRegular", size: 24)
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "MavenProRegular", size: 15)]
        dressOption.tintColor = UIColor.black
        tempOption.tintColor = UIColor.black
        dressOption.setTitleTextAttributes(titleTextAttributes, for: .normal)
//        dressOption.setTitleTextAttributes(titleTextAttributes, for: .selected)
        tempOption.setTitleTextAttributes(titleTextAttributes, for: .normal)
//        tempOption.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
    }
    
    @IBAction func doneWithSettings(_ sender: Any) {
        
        DataManager.shared.weatherVC.getWeather()
        
        self.dismiss(animated: true, completion: nil)
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
                    print("User wants ºF")
                    print(degrees)
                    UserDefaults.standard.set(degrees, forKey: degreesKey)
                }
                else {
                    
                    print("User wants ºC")
                    degrees = 1
                    print(degrees)
                    
                    UserDefaults.standard.set(degrees, forKey: degreesKey)
                }
        
        
        
        
    }
    
   

            

}

