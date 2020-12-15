//
//  TransactionTableViewModel.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 15/12/2020.
//

import Foundation
import RxSwift
import RxCocoa

class TransactionTableViewCellModel {
    
    let imagePath = BehaviorRelay<String>(value: "")
    let description = BehaviorRelay<String>(value: "")
    let category = BehaviorRelay<String>(value: "")
    let amount = BehaviorRelay<String>(value: "")
    let currency = BehaviorRelay<String>(value: "")
    
    required init(transaction: Transaction) {
        imagePath.accept(transaction.productIcon ?? "")
        description.accept(transaction.description ?? "")
        category.accept(transaction.category ?? "")
        amount.accept(String(format: "%.2f", transaction.amount ?? ""))
        currency.accept(currencyToPoundSymbol(currency: transaction.currencyIso))
    }
}
