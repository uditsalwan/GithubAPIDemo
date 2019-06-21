//
//  GitIssue.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import ObjectMapper

struct GitIssue: ImmutableMappable {
    let issueId: String?
    let issueNumber: String?
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
        createdAt = try? map.value("created_at")
        updatedAt = try? map.value("updated_at")
        commentsCount = try? map.value("comments")
        comments_url = try? map.value("comments_url")
    }
}
