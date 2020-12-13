//
//  NetworkError.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 13/12/2020.
//

import Foundation

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
            return apiPath + " - " + ERROR_MESSAGE_PARSING_ERROR
        }
    }
}
