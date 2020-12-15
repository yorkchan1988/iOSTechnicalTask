//
//  Utils.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 16/12/2020.
//

import Foundation

func currencyToPoundSymbol(currency: String?) -> String {
    switch currency {
    case "GBP":
        return "£"
    default:
        return ""
    }
}
