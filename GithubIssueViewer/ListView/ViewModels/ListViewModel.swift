//
//  ListViewModel.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import RxSwift
import RxCocoa

class ListViewModel {
    let dataProvider: DataProviderProtocol
    let bag = DisposeBag()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = BehaviorRelay<String?>(value: nil)
    let tableDataSource = BehaviorRelay<[GitIssue]>(value: [])
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    func screenTitle() -> String {
        return "Firebase Issues"
    }
    
    func getAllIssues(_ repo: String = AppConstants.firebaseRepo) {
        isLoading.accept(true)
        dataProvider.getOpenIssuesForRepo(repo).subscribe(onSuccess: { [weak self] (issuesList) in
            let sortedIssues = issuesList.sorted(by: { (a, b) -> Bool in
                guard let aDate = a.updatedAt, let bDate = b.updatedAt else {
                    return false
                }
                return aDate > bDate
            })
            self?.tableDataSource.accept(sortedIssues)
            self?.isLoading.accept(false)
        }) { [weak self] (error) in
            self?.isLoading.accept(false)
            self?.errorMessage.accept(error.localizedDescription)
        }.disposed(by: bag)
    }
    
    func commentCountForIndex(_ index: Int) -> Int {
        guard index < tableDataSource.value.count else {
            return 0
        }
        return tableDataSource.value[index].commentsCount ?? 0
    }
    
    func commentForIndex(_ index: Int) -> (String?, String?) {
        guard index < tableDataSource.value.count else {
            return (nil, nil)
        }
        let issue = tableDataSource.value[index]
        var issueNumberString: String?
        if let issueNumber = issue.issueNumber {
            issueNumberString = "\(issueNumber)"
        }
        return (issueNumberString, issue.comments_url)
    }
}
