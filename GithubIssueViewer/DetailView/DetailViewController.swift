//
//  DetailViewController.swift
//  GithubIssueViewer
//
//  Created by Udit on 23/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import RxSwift

class DetailViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: DetailViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.screenTitle()
        setupBindings()
        viewModel.getAllComments()
    }
    
    func setupBindings() {
        setupTableBindings()
        
        viewModel.isLoading.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (isLoading) in
            self?.showLoader(isLoading)
        }).disposed(by: bag)
        
        viewModel.errorMessage.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (message) in
            if let msg = message {
                self?.handleError(message: msg)
            }
        }).disposed(by: bag)
    }
    
    func setupTableBindings() {
        viewModel.tableDataSource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "CommentListCell", cellType: IssueListCell.self)) { row,element,cell in
            cell.fillCommentData(element)
            }.disposed(by: bag)
    }
}
