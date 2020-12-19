//
//  MappableApi.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 17/12/2020.
//

import Foundation
import RxSwift
import ObjectMapper

// it's the base class of api class that requires object mapping
class MappableApi<T: Mappable> {
    
    func requestMappable() -> Observable<Result<T, NetworkError>> {
        return Observable<Result<T, NetworkError>>.empty()
    }
}
