//
//  APIRequest.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import Foundation
import Alamofire

/**
 Request model to make API calls
 
 Attributes
 
    - method: HTTP metod type - get, post etc.
    - path: Path for API call
    - parameters: Parameters dictionary
    - parametersArray: Parameters array
 - Tag: APIRequest
 */
struct APIRequest {
    let method: HTTPMethod
    let path: String
    let parameters: [String: Any]
    let parametersArray: [Any]?
    
    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
        self.parameters = [:]
        self.parametersArray = nil
    }
    
    init(method: HTTPMethod, path: String, parameters: [String: Any]) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.parametersArray = nil
    }
    
    init(method: HTTPMethod, path: String, parametersArray: [Any]) {
        self.method = method
        self.path = path
        self.parameters = [:]
        self.parametersArray = parametersArray
    }
}
