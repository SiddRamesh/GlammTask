//
//  APIConstants.swift
//  GlammTask
//
//  Created by Ramesh Siddanavar on 30/03/20.
//  Copyright © 2020 Ramesh Siddanavar. All rights reserved.
//

import UIKit

struct APIServerConstants {
    
    static let serverBaseURL = URL(string: "https://developers.zomato.com/api/v2.1/")!
    static let serverKey = "c7d18bcd59048a6ab4d840e4bd30554f"  //"7743aea88c2d4f753465c610ef1cf5a8"
    static let serverTimeout = 30.0
}

protocol Endpoint {
    
    var path: String { get }
    var reqType: String { get }
}

enum APIConstants {
    
    case restaurantsList(reqParams: String)
    case citiesList(reqParams: String)
}

extension APIConstants: Endpoint {
    
    var path: String {
        
        switch self {
        case .restaurantsList(let params):
            return "/search?\(params)"
            
        case .citiesList(let params):
            return "/locations?\(params)"
        }
    }
    
    var reqType: String {
        
        switch self {
        case .restaurantsList( _), .citiesList( _):
            return "GET"
        }
    }
}
