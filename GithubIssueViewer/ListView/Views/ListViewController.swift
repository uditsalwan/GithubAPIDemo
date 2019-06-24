//
//  ListViewController.swift
//  GithubIssueViewer
//
//  Created by Udit on 21/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import RxSwift
import RxCocoa

class ListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let showCommentsSegueID = "ShowCommentsSegue"
    
    var viewModel: ListViewModel!
    let bag = DisposeBag()
    var selectedRow: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.screenTitle()
        setupBindings()
        viewModel.getAllIssues()
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
        viewModel.tableDataSource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "IssueListCell", cellType: IssueListCell.self)) { row,element,cell in
            cell.fillIssueData(element)
            }.disposed(by: bag)
        
        tableView.rx.itemSelected
            .bind(onNext: {[weak self] indexPath in
                if (self?.viewModel.commentCountForIndex(indexPath.row) ?? 0) > 0,
                    let segueID = self?.showCommentsSegueID {
                    self?.selectedRow = indexPath.row
                    self?.performSegue(withIdentifier: segueID, sender: self)
                } else {
                    self?.handleError(message: "No comments found for issue")
                }
            }).disposed(by: bag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showCommentsSegueID,
            let detailVC = segue.destination as? DetailViewController,
            let index = selectedRow {
            let dataProvider = DataProvider(network: Application.shared.networkResolver.resolveAPINetwork(),
                                            persistentManager: PersistentDataManager.shared)
            let vm = DetailViewModel(dataProvider: dataProvider)
            let (issueNumber, commentURL) = viewModel.commentForIndex(index)
            vm.issueNumber = issueNumber
            vm.commentsURL = commentURL
            detailVC.viewModel = vm
        }
    }
}
