//
//  DetailViewModel.swift
//  GithubIssueViewer
//
//  Created by Udit on 23/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import RxSwift
import RxCocoa

class DetailViewModel {
    let dataProvider: DataProviderProtocol
    let bag = DisposeBag()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = BehaviorRelay<String?>(value: nil)
    let tableDataSource = BehaviorRelay<[IssueComment]>(value: [])
    
    var issueNumber: String?
    var commentsURL: String?
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func screenTitle() -> String {
        var title = ""
        if let issueNumber = issueNumber {
            title += "Issue \(issueNumber) "
        }
        return title + "Comments"
    }
    
    func getAllComments() {
        guard let commentsURL = commentsURL else {
            return
        }
        isLoading.accept(true)
        dataProvider.getCommentsFromURL(commentsURL).subscribe(onSuccess: { [weak self] (comments) in
            self?.tableDataSource.accept(comments)
            self?.isLoading.accept(false)
        }) { [weak self] (error) in
            self?.errorMessage.accept(error.localizedDescription)
            self?.isLoading.accept(false)
        }.disposed(by: bag)
    }
}
