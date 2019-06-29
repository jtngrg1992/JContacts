//
//  Strings.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation


struct Strings {
    static let URL_CONSTRUCTION_FAILURE = "Failed to construct the url using supplied configuration"
    static let UNABLE_TO_TYPECASE_URL_RESPONSE = #"Failed to typecast variable of type "URLResponse" to "HTTPURLResponse"#
    static func UNKNOWN_STATUS_CODE(_ code: Int) -> String {
        return "Unknown status code: \(code)"
    }
}

