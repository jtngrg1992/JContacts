//
//  EditContactPresenterErrro.swift
//  JContacts
//
//  Created by Jatin Garg on 30/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

enum EditContactPresenterError: Error {
    case invalidFirstName
    case invalidLastName
    case invalidEmail
    case invalidPhone
}

extension EditContactPresenterError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidFirstName:
            return Strings.INVALID_FIRSTNAME
        case .invalidLastName:
            return Strings.INVALID_LASTNAME
        case .invalidEmail:
            return Strings.INVALID_EMAIL
        case .invalidPhone:
            return Strings.INVALID_PHONE
        }
    }
}
