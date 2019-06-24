//
//  NetworkResolver.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import Foundation

protocol NetworkResolverProtocol {
    func resolveAPINetwork() -> APINetworkProtocol
}

class NetworkResolver: NetworkResolverProtocol {
    
    let SERVER_BASE_URL = AppConstants.baseUrl
    var networkClient: NetworkClientProtocol?
    
    init() { }

    func getNetworkClient() -> NetworkClientProtocol {
        if let client = self.networkClient {
            return client
        } else {
            let config = NetworkConfiguration()
            config.setup(baseURL: "\(SERVER_BASE_URL)", token: AppConstants.accessToken)
            let newClient = NetworkClient(config)
            self.networkClient = newClient
            return newClient
        }
    }
    
    func resolveAPINetwork() -> APINetworkProtocol {
        return APINetwork(network: self.getNetworkClient())
    }
}
