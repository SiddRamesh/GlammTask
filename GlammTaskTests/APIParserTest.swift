//
//  APIParserTest.swift
//  GlammTaskTests
//
//  Created by Ramesh Siddanavar on 30/03/20.
//  Copyright © 2020 Ramesh Siddanavar. All rights reserved.
//

import XCTest

class APIParserTest: XCTestCase {
    
    var restaurnatId = ""
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testFetchWeatherAPI() {
        
        let params = String(format: "lat=%.3f&lon=%.3f&entity_type=city&count=50", 21.17, 72.83)
        
        let networking = APINetworking()
        networking.performNetworkRequest(reqEndpoint: APIConstants.restaurantsList(reqParams: params), type: AllRestaurantsData.self) { (status, response, error) in
            
            XCTAssertTrue((error == nil), "Fetch restaurant details API calling is not working as expected. Error is occuring.")
            XCTAssertTrue(response != nil, "Fetch restaurant details API calling is not working as expected.")
        }
    }
    
    func testDictionaryWithPropertiesOfObject() {
        
        let id = "123"
        let name = "Surat"
        let dict = NSDictionary(dictionary: ["id": id, "name" : name])
        
        self.mapWithDictionary(dictionary: dict)
        XCTAssertTrue(restaurnatId == id, "Convert dictionary object to Weather object method is not working as expected.")
    }
    
    func mapWithDictionary(dictionary: NSDictionary) {
        
        if dictionary["id"] != nil && !(dictionary["id"] is NSNull) {
            restaurnatId = "\(dictionary["id"]!)"
        }
    }
}
