//
//  GetTransactionListViewModelTest.swift
//  iOSTechnicalTaskTests
//
//  Created by YORK CHAN on 17/12/2020.
//

import XCTest
import RxTest
import RxBlocking
import RxSwift
import Alamofire

@testable
import iOSTechnicalTask

class GetTransactionListViewModelTest: XCTestCase {

    func test_getTransactionList_success() throws {
        // GIVEN
        let dict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "GetTransactionList_success",
            ext: "json")
        let response = GetTransactionListResponse(JSON: dict!)
        let getTransactionApi = MockGetTransactionListApi(result: .success(response!))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // WHEN
        viewModel.getTransactionList()
        
        // THEN
        do {
            let transactions = try viewModel.transactions
                .asDriver()
                .toBlocking(timeout: 1.0)
                .first() ?? []
            XCTAssertEqual(transactions.count, 10)
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_getTransactionList_networkError() throws {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // THEN
        let error = viewModel.error.subscribe(
            onNext: { error in
                XCTAssertEqual(error, serverError)
            }
        )
        
        // WHEN
        viewModel.getTransactionList()
    }
    
    func test_handleRightBarButtonPressed_changeFromViewStateEditToViewStateView() {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        viewModel.viewState.accept(.edit)
        
        // WHEN
        viewModel.changeViewState()
        
        // THEN
        do {
            let viewState = try viewModel.viewState.toBlocking(timeout: 1.0).first()
            XCTAssertEqual(viewState, .view)
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_handleRightBarButtonPressed_changeFromViewStateViewToViewStateEdit() {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        viewModel.viewState.accept(.view)
        
        // WHEN
        viewModel.changeViewState()
        
        // THEN
        do {
            let viewState = try viewModel.viewState.toBlocking(timeout: 1.0).first()
            XCTAssertEqual(viewState, .edit)
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_removeSelectedTransactions_removeSingleTransaction() {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // create mock transactions
        let transactionDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "transactions",
            ext: "json")
        let transactionResponse = GetTransactionListResponse(JSON: transactionDict!)
        let transactions = transactionResponse?.data ?? []
        viewModel.transactions.accept(transactions)
        
        // create transaction to be removed
        let singleTransactionDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "singleTransaction",
            ext: "json")
        let singleTransactionResponse = GetTransactionListResponse(JSON: singleTransactionDict!)
        let singleTransaction = singleTransactionResponse?.data ?? []
        viewModel.selectedTransactions = singleTransaction
        
        // WHEN
        viewModel.removeSelectedTransactions()
        
        // THEN
        do {
            let resultTransactions = try viewModel.transactions.toBlocking(timeout: 1.0).first()
            XCTAssertEqual(resultTransactions?.count, 9)
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_removeSelectedTransactions_removeMultipleTransaction() {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // create mock transactions
        let transactionDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "transactions",
            ext: "json")
        let transactionResponse = GetTransactionListResponse(JSON: transactionDict!)
        let transactions = transactionResponse?.data ?? []
        viewModel.transactions.accept(transactions)
        
        // create transactions to be removed
        let multipleTransactionsDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "multipleTransactions",
            ext: "json")
        let multipleTransactionsResponse = GetTransactionListResponse(JSON: multipleTransactionsDict!)
        let multipleTransactions = multipleTransactionsResponse?.data ?? []
        viewModel.selectedTransactions = multipleTransactions
        
        // WHEN
        viewModel.removeSelectedTransactions()
        
        // THEN
        do {
            let resultTransactions = try viewModel.transactions.toBlocking(timeout: 1.0).first()
            XCTAssertEqual(resultTransactions?.count, 5)
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_removeSelectedTransactions_removeEmptyTransactions() {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // create mock transactions
        let transactionDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "transactions",
            ext: "json")
        let transactionResponse = GetTransactionListResponse(JSON: transactionDict!)
        let transactions = transactionResponse?.data ?? []
        viewModel.transactions.accept(transactions)
        
        // create transactions to be removed
        viewModel.selectedTransactions = []
        
        // WHEN
        viewModel.removeSelectedTransactions()
        
        // THEN
        do {
            let resultTransactions = try viewModel.transactions.toBlocking(timeout: 1.0).first()
            XCTAssertEqual(resultTransactions?.count, 10)
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_removeSelectedTransactions_removeNonExistingTransactions() {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // create mock transactions
        let transactionDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "transactions",
            ext: "json")
        let transactionResponse = GetTransactionListResponse(JSON: transactionDict!)
        let transactions = transactionResponse?.data ?? []
        viewModel.transactions.accept(transactions)
        
        // create transactions to be removed
        let nonExistingTransactionsDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "nonExistingTransactions",
            ext: "json")
        let nonExistingTransactionsResponse = GetTransactionListResponse(JSON: nonExistingTransactionsDict!)
        let nonExistingTransactions = nonExistingTransactionsResponse?.data ?? []
        viewModel.selectedTransactions = nonExistingTransactions
        
        // WHEN
        viewModel.removeSelectedTransactions()
        
        // THEN
        do {
            let resultTransactions = try viewModel.transactions.toBlocking(timeout: 1.0).first()
            XCTAssertEqual(resultTransactions?.count, 9)
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_didSelectTransaction_validIndex() {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // create mock transactions
        let transactionDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "transactions",
            ext: "json")
        let transactionResponse = GetTransactionListResponse(JSON: transactionDict!)
        let transactions = transactionResponse?.data ?? []
        viewModel.transactions.accept(transactions)
        
        // WHEN
        do {
            try viewModel.didSelectTransaction(index: 1)
        }
        catch {
            XCTFail("Unexpected error is occurred")
        }
        
        // THEN
        XCTAssertEqual(viewModel.selectedTransactions.count, 1)
    }
    
    func test_didSelectTransaction_invalidIndex() {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // create mock transactions
        let transactionDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "transactions",
            ext: "json")
        let transactionResponse = GetTransactionListResponse(JSON: transactionDict!)
        let transactions = transactionResponse?.data ?? []
        viewModel.transactions.accept(transactions)
        
        // WHEN
        do {
            try viewModel.didSelectTransaction(index: 11)
        }
        catch {
            XCTAssertEqual(error as! AppError, AppError.unexpectedError(ERROR_MESSAGE_INVALID_INDEX))
        }
        
        // THEN
        XCTAssertEqual(viewModel.selectedTransactions.count, 0)
    }
    
    func test_didDeselectTransaction_validIndex() {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // create mock transactions
        let transactionDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "transactions",
            ext: "json")
        let transactionResponse = GetTransactionListResponse(JSON: transactionDict!)
        let transactions = transactionResponse?.data ?? []
        viewModel.transactions.accept(transactions)
        
        // create transactions to be deselected
        let multipleTransactionsDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "multipleTransactions",
            ext: "json")
        let multipleTransactionsResponse = GetTransactionListResponse(JSON: multipleTransactionsDict!)
        let multipleTransactions = multipleTransactionsResponse?.data ?? []
        viewModel.selectedTransactions = multipleTransactions
        
        // WHEN
        do {
            try viewModel.didDeselectTransaction(index: 0)
        }
        catch {
            XCTFail("Unexpected error is occurred")
        }
        
        // THEN
        XCTAssertEqual(viewModel.selectedTransactions.count, 4)
    }
    
    func test_didDeselectTransaction_invalidIndexOfTransactions() {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // create mock transactions
        let transactionDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "transactions",
            ext: "json")
        let transactionResponse = GetTransactionListResponse(JSON: transactionDict!)
        let transactions = transactionResponse?.data ?? []
        viewModel.transactions.accept(transactions)
        
        // create transactions to be deselected
        let multipleTransactionsDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "multipleTransactions",
            ext: "json")
        let multipleTransactionsResponse = GetTransactionListResponse(JSON: multipleTransactionsDict!)
        let multipleTransactions = multipleTransactionsResponse?.data ?? []
        viewModel.selectedTransactions = multipleTransactions
        
        // WHEN
        do {
            try viewModel.didDeselectTransaction(index: 11)
        }
        catch {
            XCTAssertEqual(error as! AppError, AppError.unexpectedError(ERROR_MESSAGE_INVALID_INDEX))
        }
        
        // THEN
        XCTAssertEqual(viewModel.selectedTransactions.count, 5)
    }
    
    func test_didDeselectTransaction_invalidIndexOfSelectedTransactions() {
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // create mock transactions
        let transactionDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "transactions",
            ext: "json")
        let transactionResponse = GetTransactionListResponse(JSON: transactionDict!)
        let transactions = transactionResponse?.data ?? []
        viewModel.transactions.accept(transactions)
        
        // create transactions to be deselected
        let multipleTransactionsDict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "multipleTransactions",
            ext: "json")
        let multipleTransactionsResponse = GetTransactionListResponse(JSON: multipleTransactionsDict!)
        let multipleTransactions = multipleTransactionsResponse?.data ?? []
        viewModel.selectedTransactions = multipleTransactions
        
        // WHEN
        do {
            try viewModel.didDeselectTransaction(index: 1)
        }
        catch {
            XCTAssertEqual(error as! AppError, AppError.unexpectedError(ERROR_MESSAGE_INVALID_INDEX))
        }
        
        // THEN
        XCTAssertEqual(viewModel.selectedTransactions.count, 5)
    }
}
