//
//  CityData.swift
//  GlammTask
//
//  Created by Ramesh Siddanavar on 30/03/20.
//  Copyright © 2020 Ramesh Siddanavar. All rights reserved.
//

import UIKit

struct LocationSuggestionsData: Codable {
    
    var location_suggestions: [CityData]
}

struct CityData: Codable {
    
    var city_id: Int
    var title: String
    var city_name: String
}
