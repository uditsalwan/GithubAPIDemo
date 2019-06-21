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

final class NetworkResolver: NetworkResolverProtocol {
    
    public static let shared = NetworkResolver()
    private init() { }

    let SERVER_BASE_URL = AppConstants.baseUrl

    var networkClient: NetworkClientProtocol?
    var loginNetworkClient: NetworkClientProtocol?

    func getNetworkClient() -> NetworkClientProtocol {
        if let client = self.networkClient {
            return client
        } else {
            let newClient = createNetworkClient(tokenString: AppConstants.accessToken)
            self.networkClient = newClient
            return newClient
        }
    }

    func createNetworkClient(tokenString: String?) -> NetworkClientProtocol {
        let config = NetworkConfiguration()
        config.setup(baseURL: "\(SERVER_BASE_URL)", token: tokenString)
        return NetworkClient(config)
    }
    
    func resolveAPINetwork() -> APINetworkProtocol {
        return APINetwork(network: self.getNetworkClient())
    }
}
