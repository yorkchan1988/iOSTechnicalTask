//
//  Transaction.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 13/12/2020.
//

import Foundation
import ObjectMapper

struct Transaction: Mappable, Equatable {
    var tid : String?
    var date : String?
    var description : String?
    var category : String?
    var currency : String?
    var amount : Double?
    var currencyIso: String?
    var productId : UInt32?
    var productTitle: String?
    var productIcon: String?
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        tid <- map["id"]
        date <- map["date"]
        description <- map["description"]
        category <- map["category"]
        currency <- map["currency"]
        amount <- map["amount.value"]
        currencyIso <- map["amount.currency_iso"]
        productId <- map["product.id"]
        productTitle <- map["product.title"]
        productIcon <- map["product.icon"]
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.tid == rhs.tid
    }
}

