//
//  DetailPresenterError.swift
//  JContacts
//
//  Created by Jatin Garg on 30/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

enum DetailPresenterError: Error {
    case invalidPhoneNumber
}

extension DetailPresenterError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber:
            return Strings.INVALID_PHONE
        }
    }
}
