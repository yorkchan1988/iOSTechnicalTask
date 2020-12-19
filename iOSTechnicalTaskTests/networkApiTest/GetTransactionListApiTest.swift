//
//  GetTransactionListApiTest.swift
//  iOSTechnicalTaskTests
//
//  Created by YORK CHAN on 13/12/2020.
//

import XCTest
import RxTest
import RxBlocking

@testable
import iOSTechnicalTask

class GetTransactionListApiTest: XCTestCase {
    
    func test_success() throws {
        // GIVEN
        let stub = StubResponse.shared.createStub(
            host: API_HOST,
            path: API_PATH_GET_TRANSACTION_LIST,
            json: "GetTransactionList_success.json")

        // WHEN
        let result = try GetTransactionListApi().requestMappable().toBlocking().first()

        // THEN
        XCTAssertNotNil(result)
        
        switch result {
        case .success(let response):
            XCTAssertNotNil(response.data)
            XCTAssertEqual(response.data?.count, 10)
            if let data = response.data {
                let transaction = data[0]
                XCTAssertEqual(transaction.tid, "13acb877dc4d8030c5dacbde33d3496a2ae3asdc000db4c793bda9c3228baca1a28")
                XCTAssertEqual(transaction.date, "2018-03-19")
                XCTAssertEqual(transaction.description, "Forbidden planet")
                XCTAssertEqual(transaction.category, "General")
                XCTAssertEqual(transaction.currency, "GBP")
                XCTAssertEqual(transaction.amount, 13)
                XCTAssertEqual(transaction.currencyIso, "GBP")
                XCTAssertEqual(transaction.productId, 4279)
                XCTAssertEqual(transaction.productTitle, "Lloyds Bank")
                XCTAssertEqual(transaction.productIcon, "https://storage.googleapis.com/budcraftstorage/uploads/products/lloyds-bank/Llyods_Favicon-1_161201_091641.jpg")
            }
        case .failure:
            XCTFail("Should get transaction list successfully")
        default:
            XCTFail("Result was nil")
        }

        StubResponse.shared.removeStub(stub: stub)
    }

    func test_missingFields() throws {
        // GIVEN
        let stub = StubResponse.shared.createStub(
            host: API_HOST,
            path: API_PATH_GET_TRANSACTION_LIST,
            json: "GetTransactionList_missingFields.json")
        
        // WHEN
        let result = try GetTransactionListApi().requestMappable().toBlocking().first()
        
        // THEN
        XCTAssertNotNil(result)
        
        switch result {
        case .success(let response):
            XCTAssertNotNil(response.data)
            XCTAssertEqual(response.data?.count, 1)
            if let data = response.data {
                let transaction = data[0]
                XCTAssertNil(transaction.tid)
                XCTAssertNil(transaction.date)
                XCTAssertNil(transaction.description)
                XCTAssertNil(transaction.category)
                XCTAssertNil(transaction.currency)
                XCTAssertNil(transaction.amount)
                XCTAssertNil(transaction.currencyIso)
                XCTAssertNil(transaction.productId)
                XCTAssertNil(transaction.productTitle)
                XCTAssertNil(transaction.productIcon)
            }
        case .failure:
            XCTFail("Should get transaction list successfully")
        default:
            XCTFail("Result was nil")
        }
        
        StubResponse.shared.removeStub(stub: stub)
    }
    
    func test_errorWith500StatusCode() throws {
        // GIVEN
        let stub = StubResponse.shared.create500Response(
            host: API_HOST,
            path: API_PATH_GET_TRANSACTION_LIST,
            json: "GetTransactionList_emptyResponse.json")
        
        // WHEN
        let result = try GetTransactionListApi().requestMappable().toBlocking().first()
        
        // THEN
        XCTAssertNotNil(result)
        switch result {
        case .success:
            XCTFail("No error thrown")
        case let .failure(networkError):
            XCTAssertEqual(networkError, NetworkError.serverError(API_PATH_GET_TRANSACTION_LIST))
        default:
            XCTFail("Result was nil")
        }
        
        StubResponse.shared.removeStub(stub: stub)
    }
}
