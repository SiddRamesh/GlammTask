//
//  ResponseData.swift
//  GlammTask
//
//  Created by Ramesh Siddanavar on 30/03/20.
//  Copyright © 2020 Ramesh Siddanavar. All rights reserved.
//

import UIKit

struct ResponseData {
    
    fileprivate var data: Data
    init(data: Data) {
        self.data = data
    }
}

extension ResponseData {
    
    public func decode<T: Codable>(_ type: T.Type) -> (decodedData: T?, error: Error?) {
        
        let jsonDecoder = JSONDecoder()
        do {
            let response = try  jsonDecoder.decode(T.self, from: data)
            return (response, nil)
        }
        catch let error {
            print(error.localizedDescription)
            return (nil, error)
        }
    }
}
