//
//  APINetwork.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import Foundation
import RxSwift

protocol APINetworkProtocol {
    func getOpenIssuesForRepo(_ repo: String) -> Single<[GitIssue]>
}

class APINetwork : APINetworkProtocol {
    
    let network : NetworkClientProtocol
    
    init(network: NetworkClientProtocol) {
        self.network = network
    }
    
    func getOpenIssuesForRepo(_ repo: String) -> Single<[GitIssue]> {
        let r = APIRequest(method: .get, path: "/repos/\(repo)/issues")
        return network.request(r)
    }
}
