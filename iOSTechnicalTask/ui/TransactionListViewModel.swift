//
//  TransactionListViewModel.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 13/12/2020.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class TransactionListViewModel {
    private static let TRANSACTION_SECTION_HEADER_NAME = "Transaction"
    
    let datasource = BehaviorRelay<[SectionModel<String, Transaction>]>(value: [SectionModel(model: TransactionListViewModel.TRANSACTION_SECTION_HEADER_NAME, items: [])])
    let error = PublishRelay<Error>()
    
    private let getTransactionListApi: GetTransactionListApi
    
    private let disposeBag = DisposeBag()
    
    required init(api: GetTransactionListApi) {
        self.getTransactionListApi = api
    }
    
    func getTransactionList() {
        // call api to get transactions
        getTransactionListApi.requestMappable()
            // retrieve transactions from data
            .map { ($0.data ?? [] ) }
            // map transactions into SectionModel which is used as datasource of tableview
            .map({ transactions -> [SectionModel<String, Transaction>] in
                var sections: [SectionModel<String, Transaction>] = []
                
                transactions.forEach { (transaction) in
                    // if the model name is same as TransactionListViewModel.TRANSACTION_SECTION_HEADER_NAME
                    // then append transaction into item of the SectionModel
                    if let index = sections.firstIndex(where: { $0.model == TransactionListViewModel.TRANSACTION_SECTION_HEADER_NAME }) {
                        sections[index].items.append(transaction)
                    }
                    // else create a new SectionModel (which is unexpected)
                    else {
                        let section = SectionModel(model: TransactionListViewModel.TRANSACTION_SECTION_HEADER_NAME, items: [transaction])
                        sections.append(section)
                    }
                }
                return sections
            })
            .subscribe { [weak self] (sections) in
                guard let self = self else { return }
                
                self.datasource.accept(sections)
            } onError: { [weak self] (error) in
                guard let self = self else { return }
                self.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
}
