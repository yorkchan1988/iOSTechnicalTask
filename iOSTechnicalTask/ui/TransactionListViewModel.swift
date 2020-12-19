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
    
    enum ViewState {
        case edit
        case view
    }
    
    let viewState = BehaviorRelay<ViewState>(value: .view)
    let rightBarButtonTitle = BehaviorRelay<String>(value: "Edit")
    let datasource = BehaviorRelay<[SectionModel<String, Transaction>]>(value: [SectionModel(model: TRANSACTION_SECTION_HEADER_NAME, items: [])])
    let error = PublishRelay<NetworkError>()
    
    private let getTransactionListApi: MappableApi<GetTransactionListResponse>
    
    private let disposeBag = DisposeBag()
    
    required init(api: MappableApi<GetTransactionListResponse>) {
        self.getTransactionListApi = api
    }
    
    // MARK: - Network Call
    func getTransactionList() {
        // call api to get transactions
        getTransactionListApi.requestMappable()
            .subscribe(
                onNext: { [weak self] (result) in
                    guard let self = self else { return }
                    
                    switch (result) {
                    case let .success(response):
                        // map transactions into SectionModel which is used as datasource of tableview
                        let sectionModels = response.data.map { (transactions) -> [SectionModel<String, Transaction>] in
                            var sections: [SectionModel<String, Transaction>] = []
                            transactions.forEach { (transaction) in
                                // if the model name is same as TransactionListViewModel.TRANSACTION_SECTION_HEADER_NAME
                                // then append transaction into item of the SectionModel
                                if let index = sections.firstIndex(where: { $0.model == TRANSACTION_SECTION_HEADER_NAME }) {
                                    sections[index].items.append(transaction)
                                }
                                // else create a new SectionModel (which is unexpected)
                                else {
                                    let section = SectionModel(model: TRANSACTION_SECTION_HEADER_NAME, items: [transaction])
                                    sections.append(section)
                                }
                            }
                            return sections
                        }
                        
                        if let sectionModels = sectionModels {
                            self.datasource.accept(sectionModels)
                        }
                    case let .failure(error):
                        self.error.accept(error)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - User Actions
    func handleRightBarButtonPressed() {
        changeViewState()
    }
    
    // MARK: - Utility
    private func changeViewState() {
        switch viewState.value {
        case .view:
            viewState.accept(.edit)
            rightBarButtonTitle.accept("Done")
        case .edit:
            viewState.accept(.view)
            rightBarButtonTitle.accept("Edit")
        }
    }
}
