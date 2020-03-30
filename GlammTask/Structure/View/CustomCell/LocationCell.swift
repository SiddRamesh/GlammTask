//
//  LocationCell.swift
//  GlammTask
//
//  Created by Ramesh Siddanavar on 30/03/20.
//  Copyright © 2020 Ramesh Siddanavar. All rights reserved.
//

import UIKit

final class LocationCell: UITableViewCell {
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    func configureCell(objCity: CityData) {
        
        self.lblLocation.text = objCity.title
        self.lblCity.text = objCity.city_name
    }
}
