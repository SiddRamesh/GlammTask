//
//  AppError.swift
//  GlammTask
//
//  Created by Ramesh Siddanavar on 30/03/20.
//  Copyright © 2020 Ramesh Siddanavar. All rights reserved.
//

import UIKit

//MARK:- Error Protocol
protocol ErrorProtocol: Error {
    
    var localizedTitle: String { get }
    var localizedDescription: String? { get }
    var requestedAPI: String { get }
    var code: Int { get }
}

//MARK:- Custom Error
struct APICustomError: ErrorProtocol {
    
    var localizedTitle: String
    var localizedDescription: String?
    var requestedAPI: String
    var code: Int
    
    init(title: String?, desc: String? = nil, code: Int, api: String) {
        
        self.localizedTitle = title ?? "Error"
        self.code = code
        self.requestedAPI = api
        
        if let msg = desc, msg.count > 0 {
            self.localizedDescription = msg
        }
        else {
            self.localizedDescription = getHTTPErrorMessage(status: 200)
        }
    }
    
    //MARK:- Error Messages
    func getHTTPErrorMessage(status: Int) -> String {
        
        var strMessage: String = ""
        
        switch status {
            
        //Server Errors
        case 400:
            strMessage = "The server cannot or will not process the request due to an apparent client error."
        case 401:
            strMessage = "Authentication is required and has failed or has not yet been provided."
        case 402:
            strMessage = "Authentication Required."
        case 403:
            strMessage = "The request was valid, but the server is refusing action. The user might not have the necessary permissions for a resource."
        case 404:
            strMessage = "The requested resource could not be found but may be available in the future. Subsequent requests by the client are permissible."
        case 500:
            strMessage = "A generic error message, given when an unexpected condition was encountered and no more specific message is suitable."
        case 502:
            strMessage = "The server was acting as a gateway or proxy and received an invalid response from the upstream server."
        case 503:
            strMessage = "The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state."
            
        //URL Errors
        case NSURLErrorUnknown:
            strMessage = "An unknown error occurred. Please try again in a while."
            
        default:
            strMessage = "Looks like you have an unstable network at the moment. Please try again in a while."
        }
        return strMessage
    }
}
