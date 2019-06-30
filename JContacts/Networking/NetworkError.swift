//
//  NetworkError.swift
//  JContacts
//
//  Created by Jatin Garg on 30/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case notFound, validationFailed, internalServerError, noData, other(String)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return Strings.RESOURCE_NOT_FOUND
        case .validationFailed :
            return Strings.VALIDATION_FALIED
        case .internalServerError:
            return Strings.INTERNAL_ERROR
        case .noData:
            return Strings.NULL_DATA
        case .other(let str):
            return str
        }
    }
}
