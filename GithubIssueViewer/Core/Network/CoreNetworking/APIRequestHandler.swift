//
//  APIRequestHandler.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRequestAdapter : RequestAdapter {
    var token : String? { get set }
}

/// Used to build Header fields for API requests
internal class APIRequestHandler: APIRequestAdapter {
    var token : String?
    
    static let authKey = "Authorization"
    static let tokenPrefix = "access_token "
    static let contentTypeKey = "Content-Type"
    static let contentTypeValue = "application/json"
    static let userAgentKey = "User-Agent"
    static let userAgentValue = "Mozilla/5.0"
    
    init(token:String?) {
        self.token = token
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let tokenString = token {
            urlRequest.setValue(
                "\(APIRequestHandler.tokenPrefix)\(tokenString)",
                forHTTPHeaderField: APIRequestHandler.authKey)
        }
        
        urlRequest.setValue(APIRequestHandler.contentTypeValue, forHTTPHeaderField: APIRequestHandler.contentTypeKey)
        urlRequest.setValue(APIRequestHandler.userAgentValue, forHTTPHeaderField: APIRequestHandler.userAgentKey)
        
        return urlRequest
    }
}
