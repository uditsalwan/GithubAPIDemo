//
//  IssueListCell.swift
//  GithubIssueViewer
//
//  Created by Udit on 23/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import UIKit

class IssueListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bodyLabel.textColor = .darkGray
    }
    
    func fillIssueData(_ issue: GitIssue) {
        titleLabel.text = issue.title
        bodyLabel.text = String(issue.body?.prefix(AppConstants.issueBodyDisplayLength) ?? "")
        accessoryType = issue.commentsCount == 0 ? .none : .disclosureIndicator
    }
    
    func fillCommentData(_ comment: IssueComment) {
        titleLabel.text = comment.user?.loginName
        bodyLabel.text = comment.body
    }
}
