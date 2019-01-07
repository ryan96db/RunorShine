//
//  ItemDescriptionViewController.swift
//  RunorShine
//
//  Created by Ryan DeBose-Boyd on 12/5/18.
//  Copyright © 2018 Ryan DeBose-Boyd. All rights reserved.
//

import UIKit

class ItemDescriptionViewController: UIViewController {
    
    var item = Item()
    
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = item.name
        descriptionLabel.text = item.description
        
        if item.name == "Tank Top" {
            itemImage.image = UIImage(named: "TankTop1")
        }
        if item.name == "Shorts" {
            itemImage.image = UIImage(named: "Shorts2")
        }
        if item.name == "Short-Sleeve T-Shirt" {
            itemImage.image = UIImage(named: "ShortSleeveShirt3")
        }
        if item.name == "Long-Sleeve T-Shirt" {
            itemImage.image = UIImage(named: "LongSleeveShirt4")
        }
        if item.name == "Jacket" {
            itemImage.image = UIImage(named: "LightJacket5")
        }
        if item.name == "Gloves" {
            itemImage.image = UIImage(named: "Gloves6")
        }
        if item.name == "Running Tights" {
            itemImage.image = UIImage(named: "Tights7")
        }
        if item.name == "Beanie" {
            itemImage.image = UIImage(named: "Beanie8")
        }
        if item.name == "Baseball cap"{
            itemImage.image = UIImage(named: "Cap9")
        }
        if item.name == "Sunglasses" {
            itemImage.image = UIImage(named: "Sunglasses10")
        }
        if item.name == "Sunblock" {
            itemImage.image = UIImage(named: "Sunblock11")
        }
        if item.name == "Reflective gear" {
            itemImage.image = UIImage(named: "Reflective13")
        }
        if item.name == "Go Shirtless" {
            itemImage.image = UIImage(named: "Shirtless214")
        }
        if item.name == "Track pants" {
            itemImage.image = UIImage(named: "Pants15")
        }
        
        
    }
    

    

}
