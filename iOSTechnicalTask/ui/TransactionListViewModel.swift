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
    let transactions = BehaviorRelay<[Transaction]>(value: [])
    let error = PublishRelay<NetworkError>()
    
    private let getTransactionListApi: MappableApi<GetTransactionListResponse>
    
    private var selectedTransactions: [Transaction] = []
    
    private let disposeBag = DisposeBag()
    
    required init(api: MappableApi<GetTransactionListResponse>) {
        self.getTransactionListApi = api
    }
    
    // MARK: - Public functions
    func getTransactionList() {
        // call api to get transactions
        getTransactionListApi.requestMappable()
            .subscribe(
                onNext: { [weak self] (result) in
                    guard let self = self else { return }
                    
                    switch (result) {
                    case let .success(response):
                        self.transactions.accept(response.data ?? [])
                    case let .failure(error):
                        self.error.accept(error)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    func handleRightBarButtonPressed() {
        changeViewState()
    }
    
    func removeSelectedTransactions() {
        let remainingTransactions = transactions.value.filter { !selectedTransactions.contains($0) }
        transactions.accept(remainingTransactions)
    }
    
    func didSelectTransaction(index: Int) {
        let transaction = transactions.value[index]
        selectedTransactions.append(transaction)
    }
    
    func didDeselectTransaction(index: Int) {
        let transaction = transactions.value[index]
        if let idxInSelected = selectedTransactions.firstIndex(where: { $0 == transaction }) {
            selectedTransactions.remove(at: idxInSelected)
        }
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
