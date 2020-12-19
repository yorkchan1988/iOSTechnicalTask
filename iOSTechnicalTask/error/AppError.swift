//
//  AppError.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 18/12/2020.
//

import Foundation

enum AppError: Equatable {
    case unexpectedError(String)
}

extension AppError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unexpectedError(let errorMessage):
            return errorMessage
        }
    }
}
