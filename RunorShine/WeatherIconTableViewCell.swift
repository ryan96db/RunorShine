//
//  WeatherIconTableViewCell.swift
//  RunorShine
//
//  Created by Ryan DeBose-Boyd on 1/16/19.
//  Copyright © 2019 Ryan DeBose-Boyd. All rights reserved.
//

import UIKit

class WeatherIconTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
