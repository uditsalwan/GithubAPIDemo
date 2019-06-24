//
//  IssueComment.swift
//  GithubIssueViewer
//
//  Created by Udit on 23/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import ObjectMapper

struct User: ImmutableMappable {
    let loginName: String?
    
    init(map: Map) throws {
        loginName = try? map.value("login")
    }
    
    func mapping(map: Map) {
        loginName >>> map["login"]
    }
}

/**
 Github Issue comments API response model
 
 - Tag: IssueComment
 */
struct IssueComment: ImmutableMappable {
    let user: User?
    let body: String?
    
    init(map: Map) throws {
        body = try? map.value("body")
        user = try? map.value("user")
    }
    
    func mapping(map: Map) {
        body >>> map["body"]
        user >>> map["user"]
    }
}
