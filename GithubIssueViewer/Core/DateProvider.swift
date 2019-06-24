//
//  DateProvider.swift
//  GithubIssueViewer
//
//  Created by Udit on 24/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import RxSwift
import ObjectMapper

protocol DataProviderProtocol {
    func getOpenIssuesForRepo(_ repo: String) -> Single<[GitIssue]>
    func getCommentsFromURL(_ commentsPath: String) -> Single<[IssueComment]>
}

class DataProvider: DataProviderProtocol {
    let network: APINetworkProtocol!
    let persistentManager: PersistentDataManager!
    
    let bag = DisposeBag()
    
    init(network: APINetworkProtocol, persistentManager: PersistentDataManager) {
        self.network = network
        self.persistentManager = persistentManager
    }

    // MARK: - IssueList methods
    /**
     Method for getting issue list either from CoreData or API.
     
     If JSON stored in CoreData is more than 24 hours old, get the list from API and update in CoreData
     
     - Parameter repo: Github Repository name
     - Returns: On success - Array of open issues parsed in [GitIssue](x-source-tag://GitIssue) models
     
     On error - The error either returned by the server or parsing, parsed in [APIError](x-source-tag://APIError) model
     */
    func getOpenIssuesForRepo(_ repo: String) -> Single<[GitIssue]> {
        let (date, jsonString) = persistentManager.getSavedIssuesForRepo(repo)
        guard let dateValue = date, let jsonStringValue = jsonString else {
            return self.getIssuesFromAPI(repo: repo)
        }
        
        if let diff = Calendar.current.dateComponents([.hour], from: dateValue, to: Date()).hour, diff > 24 {
            return self.getIssuesFromAPI(repo: repo)
        } else {
            let mapper = Mapper<GitIssue>()
            guard let issueList = try? mapper.mapArray(JSONString: jsonStringValue) else {
                return self.getIssuesFromAPI(repo: repo)
            }
            return Single.just(issueList)
        }
    }
    
    private func getIssuesFromAPI(repo: String) -> Single<[GitIssue]> {
        return network.getOpenIssuesForRepo(repo).map { (issueList) -> [GitIssue] in
            if let jsonString = issueList.toJSONString() {
                self.persistentManager.saveIssuesForRepo(repo, issuesJSON: jsonString)
            }
            return issueList
        }
    }
    
    // MARK: - CommentList methods
    /**
     Method for getting comment list either from CoreData or API.
     
     If JSON stored in CoreData is more than 24 hours old, get the list from API and update in CoreData
     
     - Parameter commentsPath: Comments URL path
     - Returns: On success - Array of open issues parsed in [IssueComment](x-source-tag://IssueComment) models
     
     On error - The error either returned by the server or parsing, parsed in [APIError](x-source-tag://APIError) model
     */
    func getCommentsFromURL(_ commentsPath: String) -> Single<[IssueComment]> {
        let (date, jsonString) = persistentManager.getSavedCommentsForPath(commentsPath)
        guard let dateValue = date, let jsonStringValue = jsonString else {
            return self.getCommentsFromAPI(path: commentsPath)
        }
        
        if let diff = Calendar.current.dateComponents([.hour], from: dateValue, to: Date()).hour, diff > 24 {
            return self.getCommentsFromAPI(path: commentsPath)
        } else {
            let mapper = Mapper<IssueComment>()
            guard let commentList = try? mapper.mapArray(JSONString: jsonStringValue) else {
                return self.getCommentsFromAPI(path: commentsPath)
            }
            return Single.just(commentList)
        }
    }
    
    private func getCommentsFromAPI(path: String) -> Single<[IssueComment]> {
        return network.getCommentsFromURL(path).map({ (commentList) -> [IssueComment] in
            if let jsonString = commentList.toJSONString() {
                self.persistentManager.saveCommentsForPath(path, commentsJSON: jsonString)
            }
            return commentList
        })
    }
}
