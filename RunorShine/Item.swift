//
//  Item.swift
//  RunorShine
//
//  Created by Ryan DeBose-Boyd on 12/5/18.
//  Copyright © 2018 Ryan DeBose-Boyd. All rights reserved.
//

import Foundation
import UIKit

struct Item {
    
    
    var name = ""
    var description = ""
    
    
}

class RunningGear {
    
    //Beginning of Array of Items
    
    //Array of items. Will be around 10
    // First 8 are Temperature Items
    
    let items1 = Item(name: "Tank Top", description: "A loose fitting tank top, or a siglet can help wick moisture from your body on the hotter days. ")
    let items2 = Item(name: "Shorts", description: "Wear nylon or polyester shorts for maximum comfort during your run.")
    let items3 = Item(name: "Short-Sleeve T-Shirt", description: "A comfortable short-sleeve t-shirt is ideal for mild weather conditions.")
    let items4 = Item(name: "Long-Sleeve T-Shirt", description: "A light long-sleeve t-shirt is best for when the weather is colder.")
    let items5 = Item(name: "Jacket", description: "A light jacket, preferably over a long-sleeved shirt, is the perfect balance of warmth and comfortability for running in colder weather. ")
    let items6 = Item(name: "Gloves", description: "Wear a light pair of gloves in cooler weather to keep your fingertips warm while still being able to access your phone or smartwatch.")
    let items7 = Item(name: "Running Tights", description: "Tights made of polyester or spandex can provide insulation for the lower body in colder temperatures.")
    let items8 = Item(name: "Beanie", description: "Add a beanie to your running outfit to protect your ears from the cold.")
    let items9 = Item(name: "Baseball cap", description: "A durable baseball cap will provide protection from the sun and shield your face from the rain and snow.")
    let items10 = Item(name: "Sunglasses", description: "Lightweight glasses with UV protection will help shield your eyes from sun, rain, snow, or wind.")
    let items11 = Item(name: "Sunblock", description: "Use at least 30 SPF sunblock to help prevent sunburn and exposure to harmful UV rays.")
    let items12 = Item(name: "Impossible!", description: "It can't be this hot and snowy. Try again.")
    let items13 = Item(name: "Reflective gear", description: "Wearing a reflective vest, shirt, or anything else with reflective surfaces can help people see you at night or in the fog.")
    var items14 = Item(name: "Go Shirtless", description: "")
    let items15 = Item(name: "Track pants", description: "A pair of track pants over some running tights will provide maximum warmth in colder weather.")
    
    func getItemImages(itemName: String) -> UIImage {
        switch itemName {
            
        case "Tank Top":
            return UIImage(named: "TankTop1")!
            
        case "Shorts":
            return UIImage(named: "Shorts2")!
            
        case "Short-Sleeve T-Shirt":
            return UIImage(named: "ShortSleeveShirt3")!
            
        case "Long-Sleeve T-Shirt":
            return UIImage(named: "LongSleeveShirt4")!
            
        case "Jacket":
            return UIImage(named: "LightJacket5")!
            
        case "Gloves":
            return UIImage(named: "Gloves6")!
            
        case "Running Tights":
            return UIImage(named: "Tights7")!
            
        case "Beanie":
            return UIImage(named: "Beanie8")!
            
        case "Baseball cap":
            return UIImage(named: "Cap9")!
            
        case "Sunglasses":
            return UIImage(named: "Sunglasses10")!
            
        case "Sunblock":
            return UIImage(named: "Sunblock11")!
            
        case "Reflective gear":
            return UIImage(named: "Reflective13")!
            
        case "Go Shirtless":
            return UIImage(named: "Shirtless214")!
            
        case "Track pants":
            return UIImage(named: "Pants15")!
            
        default:
            return UIImage(named: "Shorts2")!
        }
    }//End of getItemImages()
    
    
    
    
    //    //Condition Items
    
    //    //End of Array of items
}
