//
//  TransactionListViewController.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 13/12/2020.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift

class TransactionListViewController : UIViewController {
    
    @IBOutlet weak var tableViewTransaction: UITableView!
    
    var viewModel : TransactionListViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarTitle()
        registerTableViewCell()
        bindViewModel()
        viewModel.getTransactionList()
    }
    
    // MARK: - UITableView Related
    func registerTableViewCell() {
        tableViewTransaction.register(UINib(nibName: String(describing: TransactionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TransactionTableViewCell.self))
    }
    
    // MARK: - Data Binding
    func bindViewModel() {
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, Transaction>> { (datasource, tableView, indexPath, transaction) -> UITableViewCell in
            
            let cellModel = TransactionTableViewCellModel(transaction: transaction)
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TransactionTableViewCell.self), for: indexPath) as! TransactionTableViewCell
            cell.viewModel = cellModel
            
            return cell
        }
        
        viewModel.datasource.asDriver().drive(tableViewTransaction.rx.items(dataSource: datasource)).disposed(by: disposeBag)
    }
    
    // MARK: - Cosmetic / Text
    private func setNavigationBarTitle() {
        self.title = "Transaction"
    }
}
