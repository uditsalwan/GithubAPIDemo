//
//  APIRequest.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import Foundation
import Alamofire

struct APIRequest {
    let method: HTTPMethod
    let path: String
    let parameters: [String: Any]
    let parametersArray: [Any]?
    
    var isURLEncodedRequest = false
    var isRawDataRequest = false
    
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
    
    init(method: HTTPMethod, path: String, parameters: [String: Any], isURLEncodedRequest: Bool) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.parametersArray = nil
        self.isURLEncodedRequest = isURLEncodedRequest
    }
}
