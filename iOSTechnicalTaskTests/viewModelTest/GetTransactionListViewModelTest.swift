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

    func test_success() throws {
        let disposeBag = DisposeBag()
        
        // GIVEN
        let dict = loadJson(
            testClass: GetTransactionListViewModelTest.self,
            fileName: "GetTransactionList_success",
            ext: "json")
        let response = GetTransactionListResponse(JSON: dict!)
        let getTransactionApi = MockGetTransactionListApi(result: .success(response!))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // THEN
        let expectDatasourceUpdated = expectation(description: "Datasource is updated")
        viewModel.datasource.asObservable().skip(1).subscribe(
        onNext: { (sectionModels) in
            if let index = sectionModels.firstIndex(where: { $0.model == TRANSACTION_SECTION_HEADER_NAME }) {
                let sectionModel = sectionModels[index]
                XCTAssertEqual(sectionModel.items.count, 10)
                expectDatasourceUpdated.fulfill()
            }
        })
        .disposed(by: disposeBag)
        
        // WHEN
        viewModel.getTransactionList()
        
        wait(for: [expectDatasourceUpdated], timeout: 5.0)
    }
    
    func test_networkError() throws {
        let disposeBag = DisposeBag()
        
        // GIVEN
        let serverError = NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST)
        let getTransactionApi = MockGetTransactionListApi(result: .failure(serverError))
        let viewModel = TransactionListViewModel(api: getTransactionApi)
        
        // THEN
        let expectErrorOccured = expectation(description: "Server error occurred")
        viewModel.error.subscribe(
            onNext: { (error) in
                XCTAssertEqual(error, serverError)
                expectErrorOccured.fulfill()
            }
        )
        .disposed(by: disposeBag)
        
        // WHEN
        viewModel.getTransactionList()
        
        wait(for: [expectErrorOccured], timeout: 5.0)
    }
}
