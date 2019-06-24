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
    func getCommentsFromURL(_ commentsPath: String) -> Single<[IssueComment]>
}

class APINetwork : APINetworkProtocol {
    
    let network : NetworkClientProtocol
    
    init(network: NetworkClientProtocol) {
        self.network = network
    }
    
    /**
     Method for getting issue list from Github API
     
     - Parameter repo: Github Repository name
     - Returns: On success - Array of open issues parsed in [GitIssue](x-source-tag://GitIssue) models
     
        On error - The error either returned by the server or parsing, parsed in [APIError](x-source-tag://APIError) model
     */
    func getOpenIssuesForRepo(_ repo: String) -> Single<[GitIssue]> {
        let r = APIRequest(method: .get, path: "/repos/\(repo)/issues")
        return network.request(r)
    }
    
    /**
     Method for getting comments on an issue from Github API
     
     - Parameter commentsPath: URL path for the comments
     - Returns: On success - Array of comments parsed in [IssueComment](x-source-tag://IssueComment) models
     
        On error - The error either returned by the server or parsing, parsed in [APIError](x-source-tag://APIError) model
     */
    func getCommentsFromURL(_ commentsPath: String) -> Single<[IssueComment]> {
        let r = APIRequest(method: .get, path: commentsPath)
        return network.request(r)
    }
}
