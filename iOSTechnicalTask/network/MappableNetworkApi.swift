//
//  MappableNetworkApi.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 13/12/2020.
//

import Foundation
import RxSwift
import ObjectMapper

class MappableNetworkApi<T: Mappable> {
    
    func requestMappable() -> Observable<T> {
        return Observable<T>.empty()
    }
}
