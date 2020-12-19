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
        
        viewModel.viewState.observeOn(MainScheduler.instance).subscribe(
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

        
        if let barButtonItem = navigationItem.rightBarButtonItem {
            viewModel.rightBarButtonTitle.asDriver().drive(barButtonItem.rx.title).disposed(by: disposeBag)
        }
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, Transaction>> { (datasource, tableView, indexPath, transaction) -> UITableViewCell in
            
            let cellModel = TransactionTableViewCellModel(transaction: transaction)
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TransactionTableViewCell.self), for: indexPath) as! TransactionTableViewCell
            cell.viewModel = cellModel
            
            return cell
        }
        
        viewModel.datasource.asDriver().drive(tableViewTransaction.rx.items(dataSource: datasource)).disposed(by: disposeBag)
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
        UIView.animate(withDuration: 0.5, delay: 0, animations: { [weak self] () in
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
            print(indexPath.row)
            let cell = tableView.cellForRow(at: indexPath) as! TransactionTableViewCell
            cell.isSelected = true
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (tableView.isEditing) {
            print(indexPath.row)
            let cell = tableView.cellForRow(at: indexPath) as! TransactionTableViewCell
            cell.isSelected = false
        }
    }
}
