//
//  NetworkConfiguration.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import Foundation

protocol NetworkConfigurationProtocol {
    var token : String? { get set }
    var baseURL : String? { get set }
    
    func setup(baseURL: String, token: String?)
}

class NetworkConfiguration : NetworkConfigurationProtocol {
    var token : String?
    var baseURL : String?
    
    func setup(baseURL: String, token: String?) {
        self.token = token
        self.baseURL = baseURL
    }
}
