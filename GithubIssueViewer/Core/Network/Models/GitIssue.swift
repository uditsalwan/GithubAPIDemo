//
//  GitIssue.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import ObjectMapper

/**
 Github Issue search API response model
 
 - Tag: GitIssue
 */
struct GitIssue: ImmutableMappable {
    let issueId: Int?
    let issueNumber: Int?
    let title: String?
    let body: String?
    let createdAt: Date?
    let updatedAt: Date?
    let commentsCount: Int?
    let comments_url: String?
    
    init(map: Map) throws {
        issueId = try? map.value("id")
        issueNumber = try? map.value("number")
        title = try? map.value("title")
        body = try? map.value("body")
        commentsCount = try? map.value("comments")
        comments_url = try? map.value("comments_url")
        let dateTransformer = DateStringTransformer()
        createdAt = try? map.value("created_at", using: dateTransformer)
        updatedAt = try? map.value("updated_at", using: dateTransformer)
    }
    
    func mapping(map: Map) {
        issueId >>> map["id"]
        issueNumber >>> map["number"]
        title >>> map["title"]
        body >>> map["body"]
        commentsCount >>> map["comments"]
        comments_url >>> map["comments_url"]
        let dateTransformer = DateStringTransformer()
        createdAt >>> (map["created_at"], dateTransformer)
        updatedAt >>> (map["updated_at"], dateTransformer)
    }
}
