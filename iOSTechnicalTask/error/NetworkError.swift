//
//  NetworkError.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 13/12/2020.
//

import Foundation

let FAIL_TO_PARSE_ERROR_RESONSE = "Fail to parse api error."

enum NetworkError {
    case serverError(String, String)
    case parsingError(String)
}

extension NetworkError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serverError(let apiPath, let message):
            return apiPath + "-" + message
        case .parsingError(let apiPath):
            return apiPath + " - " + FAIL_TO_PARSE_ERROR_RESONSE
        }
    }
}
