//
//  GetTransactionListResponse.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 13/12/2020.
//

import Foundation
import ObjectMapper

struct GetTransactionListResponse: Mappable {
    var data : [Transaction]?
    
    init?(map: Map) {
        data = (try? map.value("data")) ?? [] // optional + default value
    }

    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}
