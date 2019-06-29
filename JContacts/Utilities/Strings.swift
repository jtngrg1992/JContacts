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
    static let INVALID_CONTACT_INDICES = "Unable to locate the requested contact information"
    static let DETAIL_EDIT_ACTION = "Edit"
    static let EDIT_CHOOSE_PIC_TITLE = "Choose an option"
    static let EDIT_PIC_CAMERA_OPTION = "Camera"
    static let EDIT_PIC_CAMERA_ROLL_OPTION = "Camera Roll"
    static let EDIT_PIC_CANCEL_OPTION = "Cancel"
    static func UNKNOWN_STATUS_CODE(_ code: Int) -> String {
        return "Unknown status code: \(code)"
    }
    static func FAILED_CELL_DESTRUCTURE(_ cellClass: String) -> String {
        return "Couldn't find a cell of type \(cellClass)"
    }
    
}

