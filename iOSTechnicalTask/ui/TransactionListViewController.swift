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
    @IBOutlet weak var viewRemoveContainer: UIView!
    @IBOutlet weak var contraintContainerViewHeight: NSLayoutConstraint!
    
    var viewModel : TransactionListViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        bindViewModel()
        viewModel.getTransactionList()
    }
    
    // MARK: - UITableView Related
    private func configureTableView() {
        tableViewTransaction.register(UINib(nibName: String(describing: TransactionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TransactionTableViewCell.self))
        tableViewTransaction.delegate = self
    }
    
    // MARK: - Data Binding
    private func bindViewModel() {
        
        // According to ViewState,
        // 1. show/hide remove button
        // 2. enable/disable TableView editing
        viewModel.viewState
            .observeOn(MainScheduler.instance)
            .subscribe(
            onNext: { [weak self] (viewState) in
                guard let self = self else { return }
                
                switch (viewState) {
                case TransactionListViewModel.ViewState.edit:
                    self.showRemoveButton()
                    self.setTableViewTransactionEditable(isEditable: true)
                    break;
                case TransactionListViewModel.ViewState.view:
                    self.hideRemoveButton()
                    self.setTableViewTransactionEditable(isEditable: false)
                    self.resetAllSelectionCell()
                    break;
                }
            }
        ).disposed(by: disposeBag)

        // change title of right UIBarButton
        if let barButtonItem = navigationItem.rightBarButtonItem {
            viewModel.rightBarButtonTitle.asDriver().drive(barButtonItem.rx.title).disposed(by: disposeBag)
        }
        
        // cell for row at indexPath
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, Transaction>> { (datasource, tableView, indexPath, transaction) -> UITableViewCell in

            let cellModel = TransactionTableViewCellModel(transaction: transaction)
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TransactionTableViewCell.self), for: indexPath) as! TransactionTableViewCell
            cell.viewModel = cellModel

            return cell
        }
        
        // map transactions to sectionModels
        viewModel.transactions
            .map({ (transactions) -> [SectionModel<String, Transaction>] in
                
                var sectionModels: [SectionModel<String, Transaction>] = []
                
                transactions.forEach { (transaction) in
                    // if the model name is same as TransactionListViewModel.TRANSACTION_SECTION_HEADER_NAME
                    // then append transaction into item of the SectionModel
                    if let index = sectionModels.firstIndex(where: { $0.model == TRANSACTION_SECTION_HEADER_NAME }) {
                        sectionModels[index].items.append(transaction)
                    }
                    // else create a new SectionModel (which is unexpected)
                    else {
                        let section = SectionModel(model: TRANSACTION_SECTION_HEADER_NAME, items: [transaction])
                        sectionModels.append(section)
                    }
                }
                
                return sectionModels
            })
            // if error, just return
            .asDriver(onErrorJustReturn: [SectionModel(model: TRANSACTION_SECTION_HEADER_NAME, items: [])])
            .drive(tableViewTransaction.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - Cosmetic / Text
    private func configureNavigationBar() {
        self.title = "Transactions"
        self.navigationItem.rightBarButtonItem = getBarButtonItem(withTitle: "Edit", action: #selector(onRightBarButtonPressed))
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func getBarButtonItem(withTitle title: String, action: Selector) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: action)
        setNavigationItemStyle(barButtonItem: barButtonItem)
        return barButtonItem
    }
    
    private func setNavigationItemStyle(barButtonItem: UIBarButtonItem) {
        let font = UIFont.systemFont(ofSize: 15)
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
    
    // MARK: - User Actions
    @objc private func onRightBarButtonPressed() {
        viewModel.handleRightBarButtonPressed()
    }
    
    @IBAction private func onRemoveButtonPressed() {
        viewModel.removeSelectedTransactions()
    }
    
    // MARK: - View State Change
    private func showRemoveButton() {
        UIView.animate(withDuration: 0.5, delay: 0, animations: { [weak self] () in
            guard let self = self else { return }
            self.viewRemoveContainer.alpha = 1
        }, completion: { [weak self] finished in
            guard let self = self else { return }
            self.viewRemoveContainer.isHidden = false
        })
    }
    
    private func hideRemoveButton() {
        UIView.animate(withDuration: 0.3, delay: 0, animations: { [weak self] () in
            guard let self = self else { return }
            self.viewRemoveContainer.alpha = 0
        }, completion: { [weak self] finished in
            guard let self = self else { return }
            self.viewRemoveContainer.isHidden = true
        })
    }
    
    private func setTableViewTransactionEditable(isEditable: Bool) {
        tableViewTransaction.isEditing = isEditable
        tableViewTransaction.allowsMultipleSelectionDuringEditing = isEditable
    }
    
    private func resetAllSelectionCell() {
        tableViewTransaction.reloadData()
    }
}

extension TransactionListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.isEditing) {
            let cell = tableView.cellForRow(at: indexPath) as! TransactionTableViewCell
            cell.viewModel.setSelected(isSelected: true)
            viewModel.didSelectTransaction(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (tableView.isEditing) {
            let cell = tableView.cellForRow(at: indexPath) as! TransactionTableViewCell
            cell.viewModel.setSelected(isSelected: false)
            viewModel.didDeselectTransaction(index: indexPath.row)
        }
    }
}
