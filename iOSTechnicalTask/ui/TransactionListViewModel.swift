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
    let isLoading = BehaviorRelay<Bool>(value: false)
    let rightBarButtonTitle = BehaviorRelay<String>(value: "Edit")
    let transactions = BehaviorRelay<[Transaction]>(value: [])
    let error = PublishRelay<NetworkError>()
    
    var selectedTransactions: [Transaction] = []
    
    private let getTransactionListApi: MappableApi<GetTransactionListResponse>
    
    private let disposeBag = DisposeBag()
    
    required init(api: MappableApi<GetTransactionListResponse>) {
        self.getTransactionListApi = api
    }
    
    // MARK: - Functions for ViewController
    func getTransactionList() {
        isLoading.accept(true)
        // call api to get transactions
        getTransactionListApi.requestMappable()
            .subscribe(
                onNext: { [weak self] (result) in
                    guard let self = self else { return }
                    
                    self.isLoading.accept(false)
                    
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
        // remove transactions from selectedTransactions
        let remainingTransactions = transactions.value.filter { !selectedTransactions.contains($0) }
        transactions.accept(remainingTransactions)
    }
    
    func didSelectTransaction(index: Int) throws {
        guard index >= 0 && index < transactions.value.count else {
            throw AppError.unexpectedError(ERROR_MESSAGE_INVALID_INDEX)
        }
        let transaction = transactions.value[index]
        selectedTransactions.append(transaction)
    }
    
    func didDeselectTransaction(index: Int) throws {
        guard index >= 0 && index < transactions.value.count else {
            throw AppError.unexpectedError(ERROR_MESSAGE_INVALID_INDEX)
        }
        // check if transaction exists
        // if yes, remove selected transactions
        let transaction = transactions.value[index]
        if let idxInSelected = selectedTransactions.firstIndex(where: { $0 == transaction }) {
            selectedTransactions.remove(at: idxInSelected)
        }
    }
    
    // MARK: - Utility
    func changeViewState() {
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
