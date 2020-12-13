//
//  TransactionListViewController.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 13/12/2020.
//

import Foundation
import UIKit

class TransactionListViewController : UIViewController {
    
    @IBOutlet weak var tableViewTransaction: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarTitle()
    }
    
    // MARK: - Cosmetic / Text
    private func setNavigationBarTitle() {
        self.title = "Transaction"
    }
}
