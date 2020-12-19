//
//  MockGetTransactionApi.swift
//  iOSTechnicalTaskTests
//
//  Created by YORK CHAN on 17/12/2020.
//

import Foundation
import Alamofire
import RxSwift

@testable
import iOSTechnicalTask

class MockGetTransactionListApi: MappableApi<GetTransactionListResponse> {
    
    private let result: Result<GetTransactionListResponse, NetworkError>
    
    init(result: Result<GetTransactionListResponse, NetworkError>) {
        self.result = result
    }
    
    override func requestMappable() -> Observable<Result<GetTransactionListResponse, NetworkError>> {
        return Observable.just(result)
    }
}
